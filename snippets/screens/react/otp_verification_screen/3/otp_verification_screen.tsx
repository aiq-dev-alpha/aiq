import React, { useState, useEffect, useRef } from 'react';
import './otp_verification_screen.css';

// Version 3: Minimal clean design with individual digit boxes

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
  const [otp, setOtp] = useState<string[]>(Array(6).fill(''));
  const [activeIndex, setActiveIndex] = useState(0);
  const [isVerifying, setIsVerifying] = useState(false);
  const [error, setError] = useState('');
  const [resendTimer, setResendTimer] = useState(30);
  const inputRefs = useRef<(HTMLInputElement | null)[]>([]);

  useEffect(() => {
    inputRefs.current[0]?.focus();
  }, []);

  useEffect(() => {
    if (resendTimer > 0) {
      const timer = setTimeout(() => setResendTimer(resendTimer - 1), 1000);
      return () => clearTimeout(timer);
    }
  }, [resendTimer]);

  useEffect(() => {
    if (otp.every(digit => digit !== '')) {
      verifyOTP();
    }
  }, [otp]);

  const handleChange = (index: number, value: string) => {
    if (!/^\d*$/.test(value)) return;

    const newOtp = [...otp];
    newOtp[index] = value.slice(-1);
    setOtp(newOtp);
    setError('');

    if (value && index < 5) {
      inputRefs.current[index + 1]?.focus();
      setActiveIndex(index + 1);
    }
  };

  const handleKeyDown = (index: number, e: React.KeyboardEvent) => {
    if (e.key === 'Backspace') {
      if (!otp[index] && index > 0) {
        const newOtp = [...otp];
        newOtp[index - 1] = '';
        setOtp(newOtp);
        inputRefs.current[index - 1]?.focus();
        setActiveIndex(index - 1);
      } else {
        const newOtp = [...otp];
        newOtp[index] = '';
        setOtp(newOtp);
      }
    } else if (e.key === 'ArrowLeft' && index > 0) {
      inputRefs.current[index - 1]?.focus();
      setActiveIndex(index - 1);
    } else if (e.key === 'ArrowRight' && index < 5) {
      inputRefs.current[index + 1]?.focus();
      setActiveIndex(index + 1);
    }
  };

  const handlePaste = (e: React.ClipboardEvent) => {
    e.preventDefault();
    const pasteData = e.clipboardData.getData('text').replace(/\D/g, '').slice(0, 6);
    const newOtp = pasteData.split('').concat(Array(6 - pasteData.length).fill(''));
    setOtp(newOtp);
    
    if (pasteData.length === 6) {
      inputRefs.current[5]?.focus();
      setActiveIndex(5);
    } else {
      inputRefs.current[pasteData.length]?.focus();
      setActiveIndex(pasteData.length);
    }
  };

  const verifyOTP = async () => {
    const code = otp.join('');
    if (code.length !== 6) return;

    setIsVerifying(true);
    setError('');

    await new Promise(resolve => setTimeout(resolve, 1200));

    if (code === '123456') {
      onVerificationSuccess?.();
    } else {
      setError('Invalid code');
      setOtp(Array(6).fill(''));
      inputRefs.current[0]?.focus();
      setActiveIndex(0);
    }

    setIsVerifying(false);
  };

  const handleResend = async () => {
    if (resendTimer > 0) return;
    setResendTimer(30);
    setOtp(Array(6).fill(''));
    setError('');
    inputRefs.current[0]?.focus();
    setActiveIndex(0);
  };

  return (
    <div className="minimal_otp">
      <div className="minimal_otp_content">
        <button className="minimal_back" onClick={onNavigateBack}>
          ← Back
        </button>

        <div className="minimal_header_otp">
          <h1>Verify code</h1>
          <p>
            Sent to {phoneNumber || email}
          </p>
        </div>

        <div className="otp_boxes" onPaste={handlePaste}>
          {otp.map((digit, index) => (
            <div
              key={index}
              className={`otp_box ${activeIndex === index ? 'active' : ''} ${digit ? 'filled' : ''} ${error ? 'error' : ''}`}
            >
              <input
                ref={el => inputRefs.current[index] = el}
                type="text"
                inputMode="numeric"
                maxLength={1}
                value={digit}
                onChange={(e) => handleChange(index, e.target.value)}
                onKeyDown={(e) => handleKeyDown(index, e)}
                onFocus={() => setActiveIndex(index)}
                disabled={isVerifying}
                className="otp_input_minimal"
              />
            </div>
          ))}
        </div>

        {isVerifying && (
          <div className="verifying_state">
            <div className="minimal_spinner"></div>
            <span>Verifying...</span>
          </div>
        )}

        {error && (
          <div className="minimal_error">
            {error}
          </div>
        )}

        <div className="resend_area">
          {resendTimer > 0 ? (
            <p className="resend_timer_text">
              Resend code in {resendTimer}s
            </p>
          ) : (
            <button className="resend_link" onClick={handleResend}>
              Resend code
            </button>
          )}
        </div>
      </div>
    </div>
  );
};

export default OTPVerificationScreen;
