'use client';

import Link from 'next/link';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Input } from '@/components/ui/input';
import { Palette, Search, Star, Users, Shield, Zap } from 'lucide-react';

export default function HomePage() {
  return (
    <div className="min-h-screen bg-white">
      <nav className="border-b">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center h-16">
            <div className="flex items-center gap-2">
              <Palette className="h-8 w-8 text-slate-900" />
              <span className="text-2xl font-bold text-slate-900">ArtConnect</span>
            </div>
            <div className="flex items-center gap-4">
              <Link href="/browse">
                <Button variant="ghost">Browse Artists</Button>
              </Link>
              <Link href="/auth/login">
                <Button variant="ghost">Sign In</Button>
              </Link>
              <Link href="/auth/register">
                <Button>Get Started</Button>
              </Link>
            </div>
          </div>
        </div>
      </nav>

      <section className="bg-gradient-to-br from-slate-50 to-slate-100 py-20">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center max-w-3xl mx-auto">
            <h1 className="text-5xl md:text-6xl font-bold text-slate-900 mb-6">
              Connect with Talented Indonesian Artists
            </h1>
            <p className="text-xl text-slate-600 mb-8">
              Find the perfect creative professional for your project. From batik to digital art, discover skilled artists ready to bring your vision to life.
            </p>
            <div className="flex gap-4 max-w-2xl mx-auto">
              <div className="flex-1 relative">
                <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-5 w-5 text-slate-400" />
                <Input
                  placeholder="Search for artists by skill or category..."
                  className="pl-10 h-12"
                />
              </div>
              <Button size="lg" className="h-12 px-8">
                Search
              </Button>
            </div>
          </div>
        </div>
      </section>

      <section className="py-20">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <h2 className="text-3xl font-bold text-center text-slate-900 mb-12">
            Why Choose ArtConnect?
          </h2>
          <div className="grid md:grid-cols-3 gap-8">
            <Card>
              <CardHeader>
                <div className="w-12 h-12 bg-slate-100 rounded-lg flex items-center justify-center mb-4">
                  <Users className="h-6 w-6 text-slate-900" />
                </div>
                <CardTitle>Verified Artists</CardTitle>
                <CardDescription>
                  All artists are carefully vetted to ensure quality and professionalism
                </CardDescription>
              </CardHeader>
            </Card>

            <Card>
              <CardHeader>
                <div className="w-12 h-12 bg-slate-100 rounded-lg flex items-center justify-center mb-4">
                  <Shield className="h-6 w-6 text-slate-900" />
                </div>
                <CardTitle>Secure Payments</CardTitle>
                <CardDescription>
                  Escrow protection ensures your funds are safe until work is completed
                </CardDescription>
              </CardHeader>
            </Card>

            <Card>
              <CardHeader>
                <div className="w-12 h-12 bg-slate-100 rounded-lg flex items-center justify-center mb-4">
                  <Zap className="h-6 w-6 text-slate-900" />
                </div>
                <CardTitle>Fast Delivery</CardTitle>
                <CardDescription>
                  Get matched with artists quickly and receive your projects on time
                </CardDescription>
              </CardHeader>
            </Card>
          </div>
        </div>
      </section>

      <section className="bg-slate-50 py-20">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <h2 className="text-3xl font-bold text-center text-slate-900 mb-12">
            Popular Categories
          </h2>
          <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
            {['Batik Design', 'Digital Art', 'Fashion Design', 'Ceramics', 'Illustration', 'Logo Design', 'Photography', 'Craft'].map((category) => (
              <Card key={category} className="hover:shadow-lg transition-shadow cursor-pointer">
                <CardContent className="p-6 text-center">
                  <h3 className="font-semibold text-slate-900">{category}</h3>
                </CardContent>
              </Card>
            ))}
          </div>
        </div>
      </section>

      <section className="py-20">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <h2 className="text-3xl font-bold text-slate-900 mb-6">
            Ready to Get Started?
          </h2>
          <p className="text-xl text-slate-600 mb-8 max-w-2xl mx-auto">
            Join thousands of clients and artists already working together on ArtConnect
          </p>
          <div className="flex gap-4 justify-center">
            <Link href="/auth/register">
              <Button size="lg" className="h-12 px-8">
                Sign Up as Client
              </Button>
            </Link>
            <Link href="/auth/register">
              <Button size="lg" variant="outline" className="h-12 px-8">
                Join as Artist
              </Button>
            </Link>
          </div>
        </div>
      </section>

      <footer className="border-t bg-slate-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
          <div className="grid md:grid-cols-4 gap-8">
            <div>
              <div className="flex items-center gap-2 mb-4">
                <Palette className="h-6 w-6 text-slate-900" />
                <span className="text-xl font-bold text-slate-900">ArtConnect</span>
              </div>
              <p className="text-slate-600 text-sm">
                Connecting Indonesian artists with clients worldwide
              </p>
            </div>
            <div>
              <h3 className="font-semibold text-slate-900 mb-4">For Clients</h3>
              <ul className="space-y-2 text-sm text-slate-600">
                <li><Link href="/browse">Browse Artists</Link></li>
                <li><Link href="/auth/register">Post a Project</Link></li>
                <li><Link href="#">How It Works</Link></li>
              </ul>
            </div>
            <div>
              <h3 className="font-semibold text-slate-900 mb-4">For Artists</h3>
              <ul className="space-y-2 text-sm text-slate-600">
                <li><Link href="/auth/register">Join as Artist</Link></li>
                <li><Link href="#">Find Projects</Link></li>
                <li><Link href="#">Success Stories</Link></li>
              </ul>
            </div>
            <div>
              <h3 className="font-semibold text-slate-900 mb-4">Company</h3>
              <ul className="space-y-2 text-sm text-slate-600">
                <li><Link href="/about">About Us</Link></li>
                <li><Link href="/contact">Contact</Link></li>
                <li><Link href="#">Terms of Service</Link></li>
              </ul>
            </div>
          </div>
          <div className="border-t mt-8 pt-8 text-center text-sm text-slate-600">
            <p>&copy; 2025 ArtConnect. All rights reserved.</p>
          </div>
        </div>
      </footer>
    </div>
  );
}
