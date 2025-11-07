'use client';

import Link from 'next/link';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Mail, Palette } from 'lucide-react';

export default function VerifyEmailPage() {
  return (
    <div className="min-h-screen flex items-center justify-center bg-gradient-to-br from-slate-50 to-slate-100 p-4">
      <div className="w-full max-w-md">
        <div className="text-center mb-8">
          <div className="inline-flex items-center gap-2 mb-4">
            <Palette className="h-8 w-8 text-slate-900" />
            <h1 className="text-3xl font-bold text-slate-900">ArtConnect</h1>
          </div>
        </div>

        <Card>
          <CardHeader className="text-center">
            <div className="mx-auto mb-4 w-16 h-16 bg-slate-100 rounded-full flex items-center justify-center">
              <Mail className="h-8 w-8 text-slate-900" />
            </div>
            <CardTitle>Check your email</CardTitle>
            <CardDescription>
              We've sent you a verification link. Please check your inbox and click the link to verify your account.
            </CardDescription>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="text-center text-sm text-slate-600">
              <p>Didn't receive the email? Check your spam folder or</p>
            </div>
            <Button variant="outline" className="w-full">
              Resend verification email
            </Button>
            <div className="text-center">
              <Link href="/auth/login">
                <Button variant="ghost" className="text-sm">
                  Back to login
                </Button>
              </Link>
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
