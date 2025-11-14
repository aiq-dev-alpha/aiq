import Link from 'next/link';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { ThemeToggle } from '@/components/ui/theme_toggle';
import { Github, Globe, Zap, Shield, Palette, Code } from 'lucide-react';

export default function Home() {
  return (
    <main className="container mx-auto px-4 py-8">
      {/* Header */}
      <header className="flex items-center justify-between mb-8">
        <div className="flex items-center gap-2">
          <div className="h-8 w-8 bg-gradient-to-r from-blue-500 to-purple-600 rounded-lg"></div>
          <h1 className="text-2xl font-bold">{{PROJECT_NAME}}</h1>
        </div>
        <ThemeToggle />
      </header>

      {/* Hero Section */}
      <section className="text-center mb-16">
        <div className="max-w-3xl mx-auto">
          <h1 className="text-4xl font-bold tracking-tight mb-4">
            Modern Next.js 14 Template
          </h1>
          <p className="text-xl text-muted-foreground mb-8">
            A production-ready starter template with TypeScript, Tailwind CSS,
            Authentication, and more modern features built-in.
          </p>
          <div className="flex gap-4 justify-center">
            <Button asChild>
              <Link href="/dashboard">Get Started</Link>
            </Button>
            <Button variant="outline" asChild>
              <Link href="/auth/signin">
                <Github className="mr-2 h-4 w-4" />
                View on GitHub
              </Link>
            </Button>
          </div>
        </div>
      </section>

      {/* Features Grid */}
      <section className="mb-16">
        <h2 className="text-3xl font-bold text-center mb-8">Features</h2>
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          <Card>
            <CardHeader>
              <div className="flex items-center gap-2">
                <Zap className="h-5 w-5 text-yellow-500" />
                <CardTitle>Next.js 14</CardTitle>
              </div>
            </CardHeader>
            <CardContent>
              <CardDescription>
                Built with the latest Next.js 14 App Router for optimal performance
                and developer experience.
              </CardDescription>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <div className="flex items-center gap-2">
                <Code className="h-5 w-5 text-blue-500" />
                <CardTitle>TypeScript</CardTitle>
              </div>
            </CardHeader>
            <CardContent>
              <CardDescription>
                Fully typed with strict TypeScript configuration for better
                development experience and fewer bugs.
              </CardDescription>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <div className="flex items-center gap-2">
                <Palette className="h-5 w-5 text-purple-500" />
                <CardTitle>Tailwind CSS</CardTitle>
              </div>
            </CardHeader>
            <CardContent>
              <CardDescription>
                Styled with Tailwind CSS and shadcn/ui components for beautiful,
                responsive designs.
              </CardDescription>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <div className="flex items-center gap-2">
                <Shield className="h-5 w-5 text-green-500" />
                <CardTitle>Authentication</CardTitle>
              </div>
            </CardHeader>
            <CardContent>
              <CardDescription>
                Pre-configured NextAuth.js setup with multiple providers and
                session management.
              </CardDescription>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <div className="flex items-center gap-2">
                <Globe className="h-5 w-5 text-indigo-500" />
                <CardTitle>SEO Ready</CardTitle>
              </div>
            </CardHeader>
            <CardContent>
              <CardDescription>
                Optimized for search engines with proper metadata, sitemap,
                and structured data.
              </CardDescription>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <div className="flex items-center gap-2">
                <Palette className="h-5 w-5 text-pink-500" />
                <CardTitle>Dark Mode</CardTitle>
              </div>
            </CardHeader>
            <CardContent>
              <CardDescription>
                Built-in dark mode support with system preference detection
                and manual toggle.
              </CardDescription>
            </CardContent>
          </Card>
        </div>
      </section>

      {/* Tech Stack */}
      <section className="text-center">
        <h2 className="text-3xl font-bold mb-8">Tech Stack</h2>
        <div className="flex flex-wrap justify-center gap-2 mb-8">
          <Badge variant="secondary">Next.js 14</Badge>
          <Badge variant="secondary">TypeScript</Badge>
          <Badge variant="secondary">Tailwind CSS</Badge>
          <Badge variant="secondary">shadcn/ui</Badge>
          <Badge variant="secondary">NextAuth.js</Badge>
          <Badge variant="secondary">Radix UI</Badge>
          <Badge variant="secondary">Lucide Icons</Badge>
          <Badge variant="secondary">ESLint</Badge>
          <Badge variant="secondary">Prettier</Badge>
        </div>
      </section>
    </main>
  );
}