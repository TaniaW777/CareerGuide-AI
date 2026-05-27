import logo from '../assets/logo.png';

export default function AppLogo({ className = '' }: { className?: string }) {
  return (
    <img src={logo} alt="CareerGuide Logo" className={className} />
  );
}
