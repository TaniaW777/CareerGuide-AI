type IconProps = { className?: string };

export function SparkleIcon({ className = '' }: IconProps) {
  return (
    <svg viewBox="0 0 24 24" className={className} fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
      <path d="M12 2l1.5 4.5L18 8l-4 1.5L12 14l-1.5-4.5L6 8l4.5-1.5L12 2z" />
      <path d="M4 14l1.5 1.5L4 17l1.5 1.5L4 20" />
      <path d="M20 14l-1.5 1.5L20 17l-1.5 1.5L20 20" />
    </svg>
  );
}

export function CheckBadgeIcon({ className = '' }: IconProps) {
  return (
    <svg viewBox="0 0 24 24" className={className} fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
      <path d="M9 12l2 2 4-4" />
      <path d="M12 2a10 10 0 100 20 10 10 0 000-20z" />
      <path d="M7 17l-2 3 2-1 2 1 2-3" />
    </svg>
  );
}

export function BrainIcon({ className = '' }: IconProps) {
  return (
    <svg viewBox="0 0 24 24" className={className} fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
      <path d="M5 12c0-4.4 2.7-8 6-8s6 3.6 6 8c0 1.5-.4 2.9-1.1 4.1" />
      <path d="M11 4c-2.4 0-4.5 1.5-5.4 3.7" />
      <path d="M13 4c2.4 0 4.5 1.5 5.4 3.7" />
      <path d="M8 20H6a2 2 0 01-2-2v-1.5" />
      <path d="M16 20h2a2 2 0 002-2v-1.5" />
    </svg>
  );
}

export function TargetIcon({ className = '' }: IconProps) {
  return (
    <svg viewBox="0 0 24 24" className={className} fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
      <circle cx="12" cy="12" r="3" />
      <circle cx="12" cy="12" r="6" />
      <path d="M12 2v4" />
      <path d="M12 18v4" />
      <path d="M2 12h4" />
      <path d="M18 12h4" />
    </svg>
  );
}

export function RobotIcon({ className = '' }: IconProps) {
  return (
    <svg viewBox="0 0 24 24" className={className} fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
      <rect x="5" y="7" width="14" height="10" rx="3" />
      <path d="M8 11h.01M16 11h.01" />
      <path d="M9 16h6" />
      <path d="M9 4h6" />
      <path d="M7 4a2 2 0 00-2 2v2" />
      <path d="M19 4a2 2 0 012 2v2" />
    </svg>
  );
}

export function BookOpenIcon({ className = '' }: IconProps) {
  return (
    <svg viewBox="0 0 24 24" className={className} fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
      <path d="M4 6.5C4 5.7 4.7 5 5.5 5H11c.8 0 1.5.7 1.5 1.5V18c0 .8-.7 1.5-1.5 1.5H5.5c-.8 0-1.5-.7-1.5-1.5V6.5z" />
      <path d="M20 6.5C20 5.7 19.3 5 18.5 5H13c-.8 0-1.5.7-1.5 1.5V18c0 .8.7 1.5 1.5 1.5h5.5c.8 0 1.5-.7 1.5-1.5V6.5z" />
      <path d="M12 6.5V19" />
      <path d="M4 9.5H12" />
      <path d="M12 9.5H20" />
    </svg>
  );
}

export function GraduationIcon({ className = '' }: IconProps) {
  return (
    <svg viewBox="0 0 24 24" className={className} fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
      <path d="M12 3L3 7l9 4 9-4-9-4z" />
      <path d="M3 7v4c0 5 4 8 9 8s9-3 9-8V7" />
      <path d="M12 7v10" />
    </svg>
  );
}

export function ProfileUserIcon({ className = '' }: IconProps) {
  return (
    <svg viewBox="0 0 24 24" className={className} fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
      <path d="M12 12a4 4 0 100-8 4 4 0 000 8z" />
      <path d="M6 22c0-3 3-5 6-5s6 2 6 5" />
    </svg>
  );
}

export function TechIcon({ className = '' }: IconProps) {
  return (
    <svg viewBox="0 0 24 24" className={className} fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
      <rect x="5" y="7" width="14" height="10" rx="2" />
      <path d="M8 21h8" />
      <path d="M12 17v4" />
      <path d="M8 11h8" />
    </svg>
  );
}

export function ArtIcon({ className = '' }: IconProps) {
  return (
    <svg viewBox="0 0 24 24" className={className} fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
      <circle cx="12" cy="9" r="3" />
      <path d="M5 19h14" />
      <path d="M5 15h14" />
      <path d="M5 19a4 4 0 014-4h6a4 4 0 014 4" />
    </svg>
  );
}

export function ScienceIcon({ className = '' }: IconProps) {
  return (
    <svg viewBox="0 0 24 24" className={className} fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
      <path d="M7 3h10" />
      <path d="M12 3v6" />
      <path d="M8 9c0 3.5 3 6.5 4 7 1-.5 4-3.5 4-7" />
      <path d="M7 21h10" />
    </svg>
  );
}

export function BusinessIcon({ className = '' }: IconProps) {
  return (
    <svg viewBox="0 0 24 24" className={className} fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
      <rect x="4" y="7" width="16" height="10" rx="2" />
      <path d="M8 7v-2a2 2 0 012-2h4a2 2 0 012 2v2" />
      <path d="M12 14h4" />
    </svg>
  );
}

export function HealthIcon({ className = '' }: IconProps) {
  return (
    <svg viewBox="0 0 24 24" className={className} fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
      <path d="M12 21s-5-4.5-8-9c-1-1.5-1-4 1-5.5 1.4-1.1 4-1 5.5.5L12 8l1.5-1.5c1.5-1.5 4.1-1.6 5.5-.5 2 1.5 2 4 1 5.5-3 4.5-8 9-8 9z" />
    </svg>
  );
}

export function SocialIcon({ className = '' }: IconProps) {
  return (
    <svg viewBox="0 0 24 24" className={className} fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
      <circle cx="12" cy="8" r="3" />
      <path d="M5 21v-2a5 5 0 015-5h4a5 5 0 015 5v2" />
      <path d="M5 10a9 9 0 0114 0" />
    </svg>
  );
}

export function EcologyIcon({ className = '' }: IconProps) {
  return (
    <svg viewBox="0 0 24 24" className={className} fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
      <path d="M12 22s-6-4.5-6-9a6 6 0 0112 0c0 4.5-6 9-6 9z" />
      <path d="M12 13V7" />
      <path d="M9 10l3-3 3 3" />
    </svg>
  );
}

export function SportIcon({ className = '' }: IconProps) {
  return (
    <svg viewBox="0 0 24 24" className={className} fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
      <circle cx="12" cy="12" r="6" />
      <path d="M12 6v12" />
      <path d="M6 12h12" />
    </svg>
  );
}

export function InfoIcon({ className = '' }: IconProps) {
  return (
    <svg viewBox="0 0 24 24" className={className} fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
      <circle cx="12" cy="12" r="9" />
      <path d="M12 8v4" />
      <path d="M12 16h.01" />
    </svg>
  );
}

export function getInterestIcon(interest: string, className = '') {
  switch (interest) {
    case 'Technologie': return <TechIcon className={className} />;
    case 'Art & Design': return <ArtIcon className={className} />;
    case 'Science': return <ScienceIcon className={className} />;
    case 'Business': return <BusinessIcon className={className} />;
    case 'Santé': return <HealthIcon className={className} />;
    case 'Social': return <SocialIcon className={className} />;
    case 'Écologie': return <EcologyIcon className={className} />;
    case 'Sport': return <SportIcon className={className} />;
    default: return <InfoIcon className={className} />;
  }
}

export type TestimonialType = 'student' | 'professional' | 'developer';

export function getTestimonialIcon(type: TestimonialType, className = '') {
  switch (type) {
    case 'student':
      return (
        <svg viewBox="0 0 24 24" className={className} fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
          <path d="M4 18v-2a8 8 0 0116 0v2" />
          <path d="M12 9l-5-3 5-3 5 3-5 3z" />
          <path d="M12 6v3" />
        </svg>
      );
    case 'developer':
      return (
        <svg viewBox="0 0 24 24" className={className} fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
          <path d="M8 4h8v16H8z" />
          <path d="M12 8h-2" />
          <path d="M12 12h-2" />
          <path d="M12 16h-2" />
        </svg>
      );
    default:
      return (
        <svg viewBox="0 0 24 24" className={className} fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
          <path d="M5 12h14" />
          <path d="M12 5l7 7-7 7" />
        </svg>
      );
  }
}
