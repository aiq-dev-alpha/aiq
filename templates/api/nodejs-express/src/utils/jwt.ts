import jwt from 'jsonwebtoken';
import { JwtPayload } from '../types';

export class JWTUtil {
  private static readonly secret = process.env.JWT_SECRET || 'fallback-secret-key';
  private static readonly expiresIn = process.env.JWT_EXPIRE || '7d';

  /**
   * Generate JWT token
   */
  static generateToken(payload: JwtPayload): string {
    return jwt.sign(payload, this.secret, {
      expiresIn: this.expiresIn,
      issuer: '{{PROJECT_NAME}}',
      audience: '{{PROJECT_NAME}}-users'
    });
  }

  /**
   * Verify JWT token
   */
  static verifyToken(token: string): JwtPayload {
    try {
      const decoded = jwt.verify(token, this.secret, {
        issuer: '{{PROJECT_NAME}}',
        audience: '{{PROJECT_NAME}}-users'
      }) as JwtPayload;
      return decoded;
    } catch (error) {
      if (error instanceof jwt.TokenExpiredError) {
        throw new Error('Token has expired');
      } else if (error instanceof jwt.JsonWebTokenError) {
        throw new Error('Invalid token');
      } else {
        throw new Error('Token verification failed');
      }
    }
  }

  /**
   * Generate refresh token (longer expiry)
   */
  static generateRefreshToken(payload: JwtPayload): string {
    return jwt.sign(payload, this.secret, {
      expiresIn: '30d',
      issuer: '{{PROJECT_NAME}}',
      audience: '{{PROJECT_NAME}}-refresh'
    });
  }

  /**
   * Verify refresh token
   */
  static verifyRefreshToken(token: string): JwtPayload {
    try {
      const decoded = jwt.verify(token, this.secret, {
        issuer: '{{PROJECT_NAME}}',
        audience: '{{PROJECT_NAME}}-refresh'
      }) as JwtPayload;
      return decoded;
    } catch (error) {
      throw new Error('Invalid refresh token');
    }
  }

  /**
   * Decode token without verification (for debugging)
   */
  static decodeToken(token: string): JwtPayload | null {
    try {
      return jwt.decode(token) as JwtPayload;
    } catch (error) {
      return null;
    }
  }

  /**
   * Get token expiry time
   */
  static getTokenExpiry(token: string): Date | null {
    const decoded = this.decodeToken(token);
    if (decoded?.exp) {
      return new Date(decoded.exp * 1000);
    }
    return null;
  }
}