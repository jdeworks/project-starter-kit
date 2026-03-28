import Counter from "./components/Counter";

export default function App() {
  return (
    <>
      <header className="header">
        <nav className="nav">
          <a href="/" className="logo">
            My Site
          </a>
          <ul className="nav-links">
            <li>
              <a href="#features">Features</a>
            </li>
            <li>
              <a href="#about">About</a>
            </li>
          </ul>
        </nav>
      </header>

      <main>
        <section className="hero">
          <h1>Welcome to My Site</h1>
          <p>A minimal starter built with React, Vite, and TypeScript.</p>
          <Counter />
        </section>

        <section id="features" className="features">
          <div className="feature-card">
            <h3>Fast</h3>
            <p>Powered by Vite for instant hot module replacement.</p>
          </div>
          <div className="feature-card">
            <h3>Typed</h3>
            <p>Full TypeScript support out of the box.</p>
          </div>
          <div className="feature-card">
            <h3>Tested</h3>
            <p>Vitest and Testing Library included for reliable tests.</p>
          </div>
        </section>
      </main>
    </>
  );
}
