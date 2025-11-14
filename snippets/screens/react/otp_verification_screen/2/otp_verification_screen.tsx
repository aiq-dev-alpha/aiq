import React, { useState, useEffect, useRef } from 'react';
import './otp_verification_screen.css';

// Version 2: Modern single-input auto-format with gradient

interface OTPVerificationScreenProps {
  phoneNumber?: string;
  email?: string;
  onVerificationSuccess?: () => void;
  onNavigateBack?: () => void;
}

export const OTPVerificationScreen: React.FC<OTPVerificationScreenProps> = ({
  phoneNumber = '+1 (555) 123-4567',
  email = '',
  onVerificationSuccess,
  onNavigateBack
}) => {
  const [otpValue, setOtpValue] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState('');
  const [countdown, setCountdown] = useState(60);
  const [isSuccess, setIsSuccess] = useState(false);
  const inputRef = useRef<HTMLInputElement>(null);

  useEffect(() => {
    const timer = setInterval(() => {
      setCountdown(prev => (prev > 0 ? prev - 1 : 0));
    }, 1000);
    return () => clearInterval(timer);
  }, []);

  useEffect(() => {
    inputRef.current?.focus();
  }, []);

  const formatOTP = (value: string): string => {
    const cleaned = value.replace(/\D/g, '');
    return cleaned.slice(0, 6).split('').join(' ');
  };

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const cleaned = e.target.value.replace(/\D/g, '');
    if (cleaned.length <= 6) {
      setOtpValue(cleaned);
      setError('');

      if (cleaned.length === 6) {
        verifyOTP(cleaned);
      }
    }
  };

  const verifyOTP = async (code: string) => {
    setIsLoading(true);
    setError('');

    await new Promise(resolve => setTimeout(resolve, 1500));

    if (code === '123456') {
      setIsSuccess(true);
      setTimeout(() => onVerificationSuccess?.(), 1000);
    } else {
      setError('Invalid code. Please try again.');
      setOtpValue('');
    }

    setIsLoading(false);
  };

  const handleResend = async () => {
    if (countdown > 0) return;

    setIsLoading(true);
    await new Promise(resolve => setTimeout(resolve, 1000));
    setIsLoading(false);
    setCountdown(60);
  };

  const handlePaste = (e: React.ClipboardEvent) => {
    e.preventDefault();
    const pasted = e.clipboardData.getData('text').replace(/\D/g, '');
    if (pasted.length <= 6) {
      setOtpValue(pasted);
      if (pasted.length === 6) {
        verifyOTP(pasted);
      }
    }
  };

  return (
    <div className="modern_otp_container">
      <div className="modern_otp_card">
        <button className="back_btn_modern" onClick={onNavigateBack}>
          ←
        </button>

        <div className="phone_icon_container">
          <div className="phone_icon">
            <div className="phone_screen"></div>
            <div className="phone_notch"></div>
          </div>
          {isSuccess && <div className="success_ring"></div>}
        </div>

        <h1 className="modern_otp_title">Enter Verification Code</h1>
        <p className="modern_otp_subtitle">
          We've sent a 6-digit code to<br />
          <strong>{phoneNumber || email}</strong>
        </p>

        <div className="otp_input_section">
          <input
            ref={inputRef}
            type="text"
            inputMode="numeric"
            value={formatOTP(otpValue)}
            onChange={handleChange}
            onPaste={handlePaste}
            placeholder="• • • • • •"
            className={`modern_otp_input ${error ? 'error' : ''} ${isSuccess ? 'success' : ''}`}
            disabled={isLoading || isSuccess}
            maxLength={11}
          />

          {isLoading && (
            <div className="verification_loader">
              <div className="loader_ring"></div>
            </div>
          )}

          {isSuccess && (
            <div className="success_checkmark">✓</div>
          )}
        </div>

        {error && (
          <div className="modern_error_msg">
            <span className="error_icon_modern">⚠</span>
            {error}
          </div>
        )}

        <div className="progress_dots">
          {[0, 1, 2, 3, 4, 5].map(i => (
            <div
              key={i}
              className={`progress_dot ${i < otpValue.length ? 'filled' : ''} ${isSuccess ? 'success' : ''}`}
            />
          ))}
        </div>

        <div className="resend_section_modern">
          {countdown > 0 ? (
            <p className="countdown_text">
              Resend code in <span className="countdown_timer">{countdown}s</span>
            </p>
          ) : (
            <button
              className="resend_btn_modern"
              onClick={handleResend}
              disabled={isLoading}
            >
              <span className="resend_icon">🔄</span>
              Resend Code
            </button>
          )}
        </div>

        <div className="help_section_modern">
          <p>Having trouble? <a href="#">Contact support</a></p>
        </div>
      </div>
    </div>
  );
};

export default OTPVerificationScreen;
