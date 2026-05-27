import Navbar from './Navbar';

export default function Layout({ children }: { children: React.ReactNode }) {
  return (
    <div className="min-h-screen flex flex-col transition-colors duration-300">
      <Navbar />
      <main className="flex-1 pt-20 md:pt-20 pb-20 md:pb-0">
        {children}
      </main>
      <footer className="hidden md:block bg-white dark:bg-gray-900 border-t border-gray-100 dark:border-gray-800 py-12">
        <div className="container mx-auto px-4 text-center">
          <p className="text-gray-500 dark:text-gray-400 text-sm">
            © 2026 CareerGuide IA. Tous droits réservés. Fonctionne hors-ligne.
          </p>
        </div>
      </footer>
    </div>
  );
}

