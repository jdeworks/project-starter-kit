import * as THREE from "three";

export function createCube(): THREE.Mesh {
  const geometry = new THREE.BoxGeometry(1, 1, 1);
  const material = new THREE.MeshStandardMaterial({ color: 0xe94560 });
  return new THREE.Mesh(geometry, material);
}
