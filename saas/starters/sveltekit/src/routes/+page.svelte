<script lang="ts">
  import { appConfig } from "$lib/config";
</script>

<svelte:head>
  <title>{appConfig.name}</title>
  <meta name="description" content={appConfig.description} />
</svelte:head>

<main class="container">
  <section class="hero">
    <h1>{appConfig.name}</h1>
    <p class="subtitle">{appConfig.description}</p>
    <a href="/api/health" class="cta-button">Check API Health</a>
  </section>

  <section class="features">
    <div class="feature-card">
      <h2>Fast</h2>
      <p>Built on SvelteKit for optimal performance.</p>
    </div>
    <div class="feature-card">
      <h2>Type-Safe</h2>
      <p>Full TypeScript support from day one.</p>
    </div>
    <div class="feature-card">
      <h2>Tested</h2>
      <p>Vitest included out of the box.</p>
    </div>
  </section>
</main>
