import { appConfig } from "@/lib/config";

export default function Home() {
  return (
    <main className="container">
      <section className="hero">
        <h1>{appConfig.name}</h1>
        <p className="subtitle">{appConfig.description}</p>
        <a href="/api/health" className="cta-button">
          Check API Health
        </a>
      </section>

      <section className="features">
        <div className="feature-card">
          <h2>Fast</h2>
          <p>Built on Next.js App Router for optimal performance.</p>
        </div>
        <div className="feature-card">
          <h2>Type-Safe</h2>
          <p>Full TypeScript support from day one.</p>
        </div>
        <div className="feature-card">
          <h2>Tested</h2>
          <p>Vitest and Testing Library included out of the box.</p>
        </div>
      </section>
    </main>
  );
}
