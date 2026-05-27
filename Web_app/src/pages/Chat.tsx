import { useState, useEffect, useRef } from 'react';
import { useOfflineStore } from '../store/useOfflineStore';
import { getChatReply } from '../services/localCareerBackend';
import aiAvatar from '../assets/ai_avatar.png';

export default function Chat() {
  const { profile, chatHistory, addChatMessage } = useOfflineStore();
  const [input, setInput] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const messagesEndRef = useRef<HTMLDivElement>(null);

  // Auto scroll to the bottom whenever messages change
  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  }, [chatHistory, isLoading]);

  const handleSend = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!input.trim() || isLoading) return;

    const userText = input.trim();
    const userMsg = { id: Date.now(), text: userText, sender: 'user' as const, timestamp: Date.now() };
    addChatMessage(userMsg);
    setInput('');
    setIsLoading(true);

    try {
      // Pass the full history so the AI has context
      const reply = await getChatReply(userText, profile, chatHistory);
      const aiMsg = {
        id: Date.now() + 1,
        text: reply,
        sender: 'ai' as const,
        timestamp: Date.now()
      };
      addChatMessage(aiMsg);
    } catch (error) {
      console.error('Erreur Chat:', error);
      addChatMessage({
        id: Date.now() + 1,
        text: "Désolé, j'ai eu un problème technique. Peux-tu reformuler ta question ?",
        sender: 'ai',
        timestamp: Date.now()
      });
    } finally {
      setIsLoading(false);
    }
  };

  const formatTime = (ts: number) => {
    const d = new Date(ts);
    return `${d.getHours().toString().padStart(2,'0')}:${d.getMinutes().toString().padStart(2,'0')}`;
  };

  return (
    <div className="flex flex-col h-[calc(100vh-5rem)] max-w-4xl mx-auto px-4 py-4 mb-16 md:mb-0">
      <div className="flex-1 bg-white dark:bg-gray-900 rounded-3xl shadow-2xl overflow-hidden border border-blue-100 dark:border-gray-700 flex flex-col">
        
        {/* ===== Chat Header ===== */}
        <div className="px-6 py-4 flex items-center justify-between bg-gradient-to-r from-blue-50 via-white to-blue-50 dark:from-gray-800 dark:via-gray-800 dark:to-gray-800 border-b border-blue-100 dark:border-gray-700">
          <div className="flex items-center gap-4">
            {/* AI Avatar - new image style */}
            <div className="relative w-14 h-14 rounded-2xl overflow-hidden ring-2 ring-blue-200 dark:ring-blue-700 shadow-lg shadow-blue-500/20 flex-shrink-0">
              <img src={aiAvatar} alt="Conseiller IA" className="w-full h-full object-cover" />
            </div>
            <div>
              <h2 className="font-black text-blue-900 dark:text-white text-lg leading-tight">Conseiller IA</h2>
              <p className="text-xs font-bold flex items-center gap-1.5 mt-0.5 text-emerald-600 dark:text-emerald-400">
                <span className="w-2 h-2 bg-emerald-500 rounded-full animate-pulse shadow-[0_0_6px_rgba(16,185,129,0.9)]" />
                Connecté • Mode Hors-ligne (Ollama)
              </p>
            </div>
          </div>
          <div className="text-right hidden md:block">
            <p className="text-xs text-gray-400 font-medium">{chatHistory.length - 1} messages</p>
          </div>
        </div>

        {/* ===== Messages area ===== */}
        <div className="flex-1 overflow-y-auto px-6 py-6 space-y-5 bg-gradient-to-b from-slate-50 to-blue-50/30 dark:from-gray-900 dark:to-gray-900/80">
          {chatHistory.map((msg) => (
            <div
              key={msg.id}
              className={`flex gap-3 items-end ${msg.sender === 'user' ? 'justify-end' : 'justify-start'} animate-in fade-in slide-in-from-bottom-2 duration-300`}
            >
              {msg.sender === 'ai' && (
                <div className="w-8 h-8 rounded-xl overflow-hidden ring-1 ring-blue-200 dark:ring-blue-700 flex-shrink-0 mb-1">
                  <img src={aiAvatar} alt="IA" className="w-full h-full object-cover" />
                </div>
              )}
              <div className={`max-w-[78%] flex flex-col ${msg.sender === 'user' ? 'items-end' : 'items-start'}`}>
                <div className={`px-5 py-3.5 rounded-2xl shadow-sm text-sm md:text-base leading-relaxed font-medium whitespace-pre-line
                  ${msg.sender === 'user'
                    ? 'bg-blue-700 text-white rounded-br-none'
                    : 'bg-white dark:bg-gray-800 text-gray-800 dark:text-gray-100 rounded-bl-none border border-gray-100 dark:border-gray-700 shadow-md'
                  }`}
                >
                  {msg.text}
                </div>
                <span className="text-[10px] text-gray-400 mt-1 px-1">{formatTime(msg.timestamp)}</span>
              </div>
              {msg.sender === 'user' && (
                <div className="w-8 h-8 rounded-xl bg-blue-700 flex items-center justify-center text-white text-xs font-black flex-shrink-0 mb-1">
                  {profile?.name?.[0]?.toUpperCase() || 'M'}
                </div>
              )}
            </div>
          ))}

          {isLoading && (
            <div className="flex gap-3 items-end justify-start">
              <div className="w-8 h-8 rounded-xl overflow-hidden ring-1 ring-blue-200 flex-shrink-0">
                <img src={aiAvatar} alt="IA" className="w-full h-full object-cover" />
              </div>
              <div className="bg-white dark:bg-gray-800 border border-gray-100 dark:border-gray-700 px-5 py-4 rounded-2xl rounded-bl-none shadow-md">
                <div className="flex gap-1.5 items-center">
                  <span className="w-2.5 h-2.5 bg-blue-400 rounded-full animate-bounce" style={{ animationDelay: '0ms' }} />
                  <span className="w-2.5 h-2.5 bg-blue-400 rounded-full animate-bounce" style={{ animationDelay: '120ms' }} />
                  <span className="w-2.5 h-2.5 bg-blue-400 rounded-full animate-bounce" style={{ animationDelay: '240ms' }} />
                </div>
              </div>
            </div>
          )}
          <div ref={messagesEndRef} />
        </div>

        {/* ===== Input area ===== */}
        <form onSubmit={handleSend} className="px-6 py-4 bg-white dark:bg-gray-800 border-t border-blue-100 dark:border-gray-700">
          {profile && (
            <p className="text-xs text-blue-400 dark:text-blue-500 mb-2 font-medium">
              Discussion de <strong>{profile.name}</strong> — {profile.education}
            </p>
          )}
          <div className="flex gap-3">
            <input
              type="text"
              value={input}
              onChange={(e) => setInput(e.target.value)}
              disabled={isLoading}
              placeholder="Posez votre question sur votre orientation..."
              className="flex-1 px-5 py-3.5 rounded-2xl border-2 border-gray-100 dark:border-gray-700 dark:bg-gray-900 dark:text-white focus:border-blue-400 focus:ring-4 focus:ring-blue-400/10 outline-none transition-all font-medium placeholder-gray-400 disabled:opacity-50"
            />
            <button
              type="submit"
              disabled={isLoading || !input.trim()}
              aria-label="Envoyer"
              className="w-14 h-14 flex items-center justify-center bg-blue-700 hover:bg-blue-800 text-white rounded-2xl shadow-lg shadow-blue-700/30 transition-all disabled:opacity-40 disabled:cursor-not-allowed active:scale-95"
            >
              <svg className="w-6 h-6 rotate-90" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2.5" d="M12 19l9 2-9-18-9 18 9-2zm0 0v-8" />
              </svg>
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}
