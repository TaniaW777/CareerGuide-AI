

import { useState } from 'react';
import axios from 'axios';
import { useOfflineStore } from '../store/useOfflineStore';

export default function Chat() {
  const { profile } = useOfflineStore();
  const [messages, setMessages] = useState([
    { id: 1, text: "Bonjour ! Je suis votre conseiller CareerGuide. Comment puis-je vous aider dans votre orientation aujourd'hui ?", sender: 'ai' },
  ]);
  const [input, setInput] = useState('');
  const [isLoading, setIsLoading] = useState(false);

  const handleSend = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!input.trim() || isLoading) return;

    const userText = input.trim();
    const userMsg = { id: Date.now(), text: userText, sender: 'user' };
    setMessages(prev => [...prev, userMsg]);
    setInput('');
    setIsLoading(true);

    try {
      const backendUrl = import.meta.env.VITE_BACKEND_URL || 'http://localhost:8000';
      const response = await axios.post(`${backendUrl}/chat/`, {
        message: userText,
        profile: profile
      });

      const aiMsg = {
        id: Date.now() + 1,
        text: response.data.reply,
        sender: 'ai'
      };
      setMessages(prev => [...prev, aiMsg]);
    } catch (error) {
      console.error('Erreur Chat:', error);
      const errorMsg = {
        id: Date.now() + 1,
        text: "Désolé, j'ai rencontré une petite difficulté technique. Peux-tu reformuler ta question ?",
        sender: 'ai'
      };
      setMessages(prev => [...prev, errorMsg]);
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="flex flex-col h-[calc(100vh-8rem)] max-w-4xl mx-auto px-4 py-4 mb-20 md:mb-0">
      <div className="flex-1 bg-white dark:bg-gray-800 rounded-3xl shadow-xl overflow-hidden border border-gray-100 dark:border-gray-700 flex flex-col">
        {/* Chat Header */}
        <div className="px-6 py-4 border-b border-gray-100 dark:border-gray-700 flex items-center justify-between bg-indigo-50/50 dark:bg-indigo-900/10">
          <div className="flex items-center gap-3">
            <div className="w-12 h-12 bg-indigo-600 rounded-2xl flex items-center justify-center text-white text-2xl shadow-lg shadow-indigo-500/20 rotate-3">
              🤖
            </div>
            <div>
              <h2 className="font-bold text-gray-900 dark:text-white leading-tight">Conseiller IA - CareerGuide</h2>
              <p className="text-xs text-green-500 font-medium flex items-center gap-1">
                <span className="w-2 h-2 bg-green-500 rounded-full animate-pulse" />
                Prête à vous guider
              </p>
            </div>
          </div>
        </div>

        {/* Messages area */}
        <div className="flex-1 overflow-y-auto p-6 space-y-6 bg-gray-50/30 dark:bg-gray-900/10">
          {messages.map((msg) => (
            <div key={msg.id} className={`flex ${msg.sender === 'user' ? 'justify-end' : 'justify-start'} animate-in fade-in slide-in-from-bottom-2 duration-300`}>
              <div className={`max-w-[85%] px-6 py-4 rounded-3xl shadow-sm
                ${msg.sender === 'user' 
                  ? 'bg-indigo-600 text-white rounded-tr-none' 
                  : 'bg-white dark:bg-gray-700 text-gray-800 dark:text-gray-200 rounded-tl-none border border-gray-100 dark:border-gray-600'}
              `}>
                <p className="leading-relaxed font-medium">{msg.text}</p>
              </div>
            </div>
          ))}
          {isLoading && (
            <div className="flex justify-start">
              <div className="bg-white dark:bg-gray-700 px-6 py-4 rounded-3xl rounded-tl-none border border-gray-100 dark:border-gray-600">
                <div className="flex gap-1">
                  <span className="w-2 h-2 bg-indigo-400 rounded-full animate-bounce" />
                  <span className="w-2 h-2 bg-indigo-400 rounded-full animate-bounce delay-100" />
                  <span className="w-2 h-2 bg-indigo-400 rounded-full animate-bounce delay-200" />
                </div>
              </div>
            </div>
          )}
        </div>

        {/* Input area */}
        <form onSubmit={handleSend} className="p-6 border-t border-gray-100 dark:border-gray-700 bg-white dark:bg-gray-800">
          <div className="flex gap-4">
            <input
              type="text"
              value={input}
              onChange={(e) => setInput(e.target.value)}
              disabled={isLoading}
              placeholder="Posez votre question sur votre orientation..."
              className="flex-1 px-6 py-4 rounded-2xl border-2 border-gray-100 dark:border-gray-700 dark:bg-gray-900 focus:border-indigo-500 focus:ring-4 focus:ring-indigo-500/10 outline-none transition-all font-medium disabled:opacity-50"
            />
            <button
              type="submit"
              disabled={isLoading || !input.trim()}
              className="px-6 bg-indigo-600 text-white rounded-2xl hover:bg-indigo-700 transition-all shadow-xl shadow-indigo-500/20 disabled:opacity-50 active:scale-95"
            >
              <svg className="w-6 h-6 rotate-90" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="3" d="M12 19l9 2-9-18-9 18 9-2zm0 0v-8" />
              </svg>
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}


