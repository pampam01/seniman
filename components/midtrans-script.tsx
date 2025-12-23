'use client';

import Script from 'next/script';
import { useEffect, useState } from 'react';

export function MidtransScript() {
  const [clientKey, setClientKey] = useState<string>('');

  useEffect(() => {
    // We can't access process.env.NEXT_PUBLIC_MIDTRANS_CLIENT_KEY directly in the client component
    // if it wasn't statically embedded at build time, but it should be since it starts with NEXT_PUBLIC_.
    // However, to be safe or dynamic, sometimes it's passed via props or API.
    // For now, assume it's available via process.env.
    setClientKey(process.env.NEXT_PUBLIC_MIDTRANS_CLIENT_KEY || '');
  }, []);

  if (!clientKey) return null;

  return (
    <Script
      src="https://app.sandbox.midtrans.com/snap/snap.js"
      data-client-key={clientKey}
      strategy="lazyOnload"
    />
  );
}
