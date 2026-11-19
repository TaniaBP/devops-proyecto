#!/usr/bin/env bash
set -u

echo "=== AUDIT DE SEGURIDAD ==="
echo ""

echo "1. .gitignore incluye .env:"
if [ -f .gitignore ] && grep -qE "^\.env(\.|\*|$)" .gitignore; then
  echo "  ✅ OK"
else
  echo "  ❌ FALTA"
fi

echo "2. No hay secrets en el código:"
if command -v gitleaks >/dev/null 2>&1; then
  gitleaks detect --source . --no-git --exit-code 0 >/dev/null 2>&1 && echo "  ✅ OK" || echo "  ❌ REVISAR"
else
  echo "  ❌ REVISAR (gitleaks no instalado)"
fi

echo "3. Dependabot configurado:"
if [ -f .github/dependabot.yml ] || [ -f .github/dependabot.yaml ]; then
  echo "  ✅ OK"
else
  echo "  ❌ FALTA"
fi

echo "4. Trivy en el pipeline:"
if [ -f .github/workflows/ci.yml ] && grep -qi "trivy" .github/workflows/ci.yml; then
  echo "  ✅ OK"
else
  echo "  ❌ FALTA"
fi

echo "5. Dockerfile no usa imagen latest:"
if [ -f Dockerfile ] && ! grep -qE "^FROM .*:latest(\s|$)" Dockerfile; then
  echo "  ✅ OK"
else
  echo "  ❌ USAR VERSION FIJA"
fi

echo "6. Dockerfile usa usuario no root:"
if [ -f Dockerfile ] && grep -qE "^USER\s+[^root\s]+" Dockerfile; then
  echo "  ✅ OK"
else
  echo "  ❌ FALTA USER appuser"
fi

echo ""
echo "=== FIN DEL AUDIT ==="
