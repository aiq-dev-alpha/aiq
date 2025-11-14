import type { Metadata } from 'next';
import { Inter } from 'next/font/google';
import { ThemeProvider } from '@/components/providers/theme_provider';
import { AuthProvider } from '@/components/providers/auth_provider';
import { Toaster } from '@/components/ui/toaster';
import '@/styles/globals.css';

const inter = Inter({ subsets: ['latin'] });

export const metadata: Metadata = {
  title: {
    default: '{{PROJECT_NAME}}',
    template: '%s | {{PROJECT_NAME}}',
  },
  description: 'A modern Next.js 14 application with TypeScript, Tailwind CSS, and more.',
  keywords: ['Next.js', 'TypeScript', 'Tailwind CSS', 'React'],
  authors: [{ name: 'Your Name' }],
  creator: 'Your Name',
  metadataBase: new URL('{{BASE_URL}}'),
  openGraph: {
    type: 'website',
    locale: 'en_US',
    url: '{{BASE_URL}}',
    title: '{{PROJECT_NAME}}',
    description: 'A modern Next.js 14 application with TypeScript, Tailwind CSS, and more.',
    siteName: '{{PROJECT_NAME}}',
  },
  twitter: {
    card: 'summary_large_image',
    title: '{{PROJECT_NAME}}',
    description: 'A modern Next.js 14 application with TypeScript, Tailwind CSS, and more.',
    creator: '@yourhandle',
  },
  robots: {
    index: true,
    follow: true,
    googleBot: {
      index: true,
      follow: true,
      'max-video-preview': -1,
      'max-image-preview': 'large',
      'max-snippet': -1,
    },
  },
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en" suppressHydrationWarning>
      <body className={inter.className}>
        <ThemeProvider
          attribute="class"
          defaultTheme="system"
          enableSystem
          disableTransitionOnChange
        >
          <AuthProvider>
            <div className="relative flex min-h-screen flex-col">
              <div className="flex-1">{children}</div>
            </div>
            <Toaster />
          </AuthProvider>
        </ThemeProvider>
      </body>
    </html>
  );
}