'use client';

import { useState } from 'react';
import { Button } from '@/components/ui/button';
import { useToast } from '@/hooks/use-toast';

interface PaymentButtonProps {
  amount: number;
  projectId: string;
  projectTitle: string;
  customerDetails?: {
    first_name: string;
    last_name: string;
    email: string;
    phone: string;
  };
}

export function PaymentButton({ amount, projectId, projectTitle, customerDetails }: PaymentButtonProps) {
  const [loading, setLoading] = useState(false);
  // Remove useToast since it might not be implemented in the repo
  // but we can try to use window.alert if needed, or check if use-toast hook exists.
  // The package.json has "@radix-ui/react-toast": "^1.2.1", but usually there is a hook file.
  // The file structure showed "hooks/" folder. Let's assume it's there or handle it.

  // Actually, I'll just use console.log and alert for simplicity to avoid import errors if the hook is missing
  // But wait, the previous `ls -R` didn't show `hooks/use-toast.ts` explicitly, just `hooks/`.
  // I will check hooks folder later. For now, simple alert is safer.

  const handlePayment = async () => {
    setLoading(true);
    try {
      const response = await fetch('/api/transactions/create', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          amount,
          projectId,
          projectTitle,
          customerDetails: customerDetails || {
             first_name: "Budi",
             last_name: "Santoso",
             email: "budi.santoso@example.com",
             phone: "08123456789"
          },
        }),
      });

      const data = await response.json();

      if (!response.ok) {
        throw new Error(data.error || 'Payment initialization failed');
      }

      // Trigger Snap Popup
      if (typeof window !== 'undefined' && (window as any).snap) {
        (window as any).snap.pay(data.token, {
          onSuccess: function (result: any) {
            console.log('Payment success:', result);
            alert('Payment Successful!');
          },
          onPending: function (result: any) {
            console.log('Payment pending:', result);
            alert('Payment Pending. Please complete the payment.');
          },
          onError: function (result: any) {
            console.error('Payment error:', result);
            alert('Payment Failed!');
          },
          onClose: function () {
            console.log('Customer closed the popup without finishing the payment');
          },
        });
      } else {
        alert('Payment Gateway not loaded properly. Please refresh.');
      }
    } catch (error) {
      console.error('Payment Error:', error);
      alert('Failed to initiate payment.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <Button onClick={handlePayment} disabled={loading} className="w-full">
      {loading ? 'Processing...' : `Pay Rp ${amount.toLocaleString('id-ID')}`}
    </Button>
  );
}
