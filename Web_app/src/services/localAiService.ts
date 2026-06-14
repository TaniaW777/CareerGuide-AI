import { pipeline, env } from '@xenova/transformers';

// Configure Transformers.js to not use local models since they are not in the repo
// It will download them from Hugging Face Hub directly into the browser cache
env.allowLocalModels = false;

// We use a lightweight model for text generation / summarization
const MODEL_NAME = 'Xenova/LaMini-Flan-T5-77M';

class LocalAIService {
  private generator: any = null;
  private isInitializing: boolean = false;
  private initPromise: Promise<void> | null = null;

  async init() {
    if (this.generator) return;
    if (this.isInitializing && this.initPromise) {
      return this.initPromise;
    }

    this.isInitializing = true;
    this.initPromise = (async () => {
      try {
        console.log(`[LocalAIService] Downloading/Loading model ${MODEL_NAME}...`);
        this.generator = await pipeline('text2text-generation', MODEL_NAME);
        console.log(`[LocalAIService] Model ${MODEL_NAME} loaded successfully.`);
      } catch (error) {
        console.error('[LocalAIService] Failed to initialize model:', error);
        throw error;
      } finally {
        this.isInitializing = false;
      }
    })();

    return this.initPromise;
  }

  async reformulate(text: string): Promise<string> {
    await this.init();
    try {
      const prompt = `Reformulate the following sentence in French in a friendly tone: "${text}"`;
      const result = await this.generator(prompt, { max_new_tokens: 50, temperature: 0.7 });
      return result[0]?.generated_text?.trim() || text;
    } catch (error) {
      console.error('[LocalAIService] Reformulation failed:', error);
      return text;
    }
  }

  async summarizeProfile(profile: any): Promise<string> {
    await this.init();
    try {
      const prompt = `Summarize in French the profile of this student for career guidance. Name: ${profile.name || 'Student'}, Level: ${profile.education || 'Unknown'}, Interests: ${profile.interests.join(', ') || 'None'}, Skills: ${profile.skills || 'None'}. Make it short and encouraging.`;
      const result = await this.generator(prompt, { max_new_tokens: 80, temperature: 0.5 });
      return result[0]?.generated_text?.trim() || 'Profil intéressant !';
    } catch (error) {
      console.error('[LocalAIService] Summarization failed:', error);
      return 'Ton profil est enregistré et prêt pour l\'analyse.';
    }
  }
}

export const localAiService = new LocalAIService();
