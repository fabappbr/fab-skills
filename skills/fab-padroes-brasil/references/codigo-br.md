# Código brasileiro pronto: `src/lib/br.ts`

Copie o bloco abaixo inteiro para `src/lib/br.ts`. Ele foi executado contra casos conferidos à mão: CPF `529.982.247-25` válido e `529.982.247-24` inválido; CNPJ numérico `11.222.333/0001-81`; o primeiro CNPJ alfanumérico emitido pela Receita (`00.000.000/E08G-12`, 31/07/2026) e o exemplo oficial `12.ABC.345/01DE-35`; 67 DDDs; celular com 9 começando em 9; CEP; `0.1 + 0.2` em centavos; parcelas que somam o total; Páscoa de 2025, 2026 e 2027; consulta real ao ViaCEP. Não reescreva a lógica: use as funções.

```ts
// src/lib/br.ts: validação e formatação de dados brasileiros (sem dependência externa)

// ---------- CPF ----------
export function onlyDigits(v: string): string {
  return String(v ?? "").replace(/\D/g, "");
}

export function isValidCpf(input: string): boolean {
  const cpf = onlyDigits(input);
  if (cpf.length !== 11 || /^(\d)\1{10}$/.test(cpf)) return false;
  const dv = (len: number) => {
    let sum = 0;
    for (let i = 0; i < len; i++) sum += Number(cpf[i]) * (len + 1 - i);
    const r = sum % 11;
    return r < 2 ? 0 : 11 - r;
  };
  return dv(9) === Number(cpf[9]) && dv(10) === Number(cpf[10]);
}

export function formatCpf(input: string): string {
  const d = onlyDigits(input).slice(0, 11);
  return d
    .replace(/^(\d{3})(\d)/, "$1.$2")
    .replace(/^(\d{3})\.(\d{3})(\d)/, "$1.$2.$3")
    .replace(/\.(\d{3})(\d{1,2})$/, ".$1-$2");
}

// ---------- CNPJ (numérico e alfanumérico, IN RFB 2.229/2024) ----------
// 12 primeiras posições: 0-9 ou A-Z. 2 últimas: dígitos. Valor de cada caractere = código ASCII - 48
// (0..9 = 0..9, A = 17, B = 18, ..., Z = 42). Módulo 11 com pesos 2..9 da direita para a esquerda.
export function normalizeCnpj(input: string): string {
  return String(input ?? "").toUpperCase().replace(/[^0-9A-Z]/g, "");
}

export function isValidCnpj(input: string): boolean {
  const c = normalizeCnpj(input);
  if (!/^[0-9A-Z]{12}\d{2}$/.test(c)) return false;
  if (/^(.)\1{13}$/.test(c)) return false;
  const dv = (len: number) => {
    let sum = 0;
    let w = 2;
    for (let i = len - 1; i >= 0; i--) {
      sum += (c.charCodeAt(i) - 48) * w;
      w = w === 9 ? 2 : w + 1;
    }
    const r = sum % 11;
    return r < 2 ? 0 : 11 - r;
  };
  return dv(12) === Number(c[12]) && dv(13) === Number(c[13]);
}

export function formatCnpj(input: string): string {
  const c = normalizeCnpj(input).slice(0, 14);
  const p = [c.slice(0, 2), c.slice(2, 5), c.slice(5, 8), c.slice(8, 12), c.slice(12, 14)];
  let out = p[0];
  if (p[1]) out += "." + p[1];
  if (p[2]) out += "." + p[2];
  if (p[3]) out += "/" + p[3];
  if (p[4]) out += "-" + p[4];
  return out;
}

// ---------- Telefone ----------
export const DDDS = new Set([
  11, 12, 13, 14, 15, 16, 17, 18, 19, 21, 22, 24, 27, 28, 31, 32, 33, 34, 35, 37, 38,
  41, 42, 43, 44, 45, 46, 47, 48, 49, 51, 53, 54, 55, 61, 62, 63, 64, 65, 66, 67, 68, 69,
  71, 73, 74, 75, 77, 79, 81, 82, 83, 84, 85, 86, 87, 88, 89, 91, 92, 93, 94, 95, 96, 97, 98, 99,
]);

export type BrPhone = { e164: string; ddd: string; number: string; kind: "celular" | "fixo" };

// Aceita "(11) 91234-5678", "11912345678", "+55 11 91234-5678", "5511912345678".
export function parseBrPhone(input: string): BrPhone | null {
  let d = onlyDigits(input);
  if ((d.length === 12 || d.length === 13) && d.startsWith("55")) d = d.slice(2);
  if (d.length === 11 && d.startsWith("0")) return null;
  if (d.length !== 10 && d.length !== 11) return null;
  const ddd = d.slice(0, 2);
  const number = d.slice(2);
  if (!DDDS.has(Number(ddd))) return null;
  if (number.length === 9 && number[0] !== "9") return null; // celular: 9 dígitos começando com 9
  if (number.length === 8 && !/^[2-5]/.test(number)) return null; // fixo: 8 dígitos começando com 2 a 5
  return { e164: `+55${ddd}${number}`, ddd, number, kind: number.length === 9 ? "celular" : "fixo" };
}

export function formatBrPhone(input: string): string {
  const p = parseBrPhone(input);
  if (!p) return String(input ?? "");
  const n = p.number;
  return n.length === 9 ? `(${p.ddd}) ${n.slice(0, 5)}-${n.slice(5)}` : `(${p.ddd}) ${n.slice(0, 4)}-${n.slice(4)}`;
}

export function whatsappLink(phone: string, text?: string): string | null {
  const p = parseBrPhone(phone);
  if (!p || p.kind !== "celular") return null;
  const base = `https://wa.me/${p.e164.slice(1)}`;
  return text ? `${base}?text=${encodeURIComponent(text)}` : base;
}

// ---------- CEP ----------
export function isValidCep(input: string): boolean {
  const d = onlyDigits(input);
  return d.length === 8 && d !== "00000000";
}

export function formatCep(input: string): string {
  const d = onlyDigits(input).slice(0, 8);
  return d.length > 5 ? `${d.slice(0, 5)}-${d.slice(5)}` : d;
}

export type CepAddress = { cep: string; street: string; district: string; city: string; state: string };

// Consulta pública ao ViaCEP direto do navegador. Só o CEP sai do app. null = não achou ou falhou:
// a tela deixa o dono/cliente digitar o endereço à mão.
export async function lookupCep(input: string): Promise<CepAddress | null> {
  const cep = onlyDigits(input);
  if (!isValidCep(cep)) return null;
  const ctrl = new AbortController();
  const timer = setTimeout(() => ctrl.abort(), 5000);
  try {
    const res = await fetch(`https://viacep.com.br/ws/${cep}/json/`, { signal: ctrl.signal });
    if (!res.ok) return null;
    const j = await res.json();
    if (!j || j.erro) return null;
    return { cep: formatCep(cep), street: j.logradouro ?? "", district: j.bairro ?? "", city: j.localidade ?? "", state: j.uf ?? "" };
  } catch {
    return null;
  } finally {
    clearTimeout(timer);
  }
}

// ---------- Dinheiro ----------
// Soma em centavos inteiros e volta para reais: nunca somar float direto.
export function toCents(v: number): number {
  return Math.round((Number(v) || 0) * 100);
}
export function sumMoney(values: number[]): number {
  return values.reduce((s, v) => s + toCents(v), 0) / 100;
}
export function lineTotal(unitPrice: number, qty: number): number {
  return (toCents(unitPrice) * qty) / 100;
}
export function applyDiscountPercent(value: number, percent: number): number {
  return Math.round(toCents(value) * (1 - percent / 100)) / 100;
}
// Divide um valor em N parcelas: a diferença de centavos vai na primeira.
export function splitInstallments(total: number, n: number): number[] {
  const cents = toCents(total);
  const base = Math.floor(cents / n);
  const rest = cents - base * n;
  return Array.from({ length: n }, (_, i) => (base + (i === 0 ? rest : 0)) / 100);
}

// ---------- Datas e feriados ----------
const TZ = "America/Sao_Paulo";
// "Hoje" no fuso do negócio, como "aaaa-mm-dd" (nunca toISOString, que é UTC e vira o dia às 21h).
export function todayBr(): string {
  return new Intl.DateTimeFormat("en-CA", { timeZone: TZ, year: "numeric", month: "2-digit", day: "2-digit" }).format(new Date());
}

function ymd(y: number, m: number, d: number): string {
  return `${y}-${String(m).padStart(2, "0")}-${String(d).padStart(2, "0")}`;
}
function addDays(y: number, m: number, d: number, n: number): string {
  const dt = new Date(Date.UTC(y, m - 1, d + n));
  return ymd(dt.getUTCFullYear(), dt.getUTCMonth() + 1, dt.getUTCDate());
}
// Domingo de Páscoa (algoritmo de Meeus/Jones/Butcher, calendário gregoriano).
export function easter(year: number): { m: number; d: number } {
  const a = year % 19, b = Math.floor(year / 100), c = year % 100;
  const d = Math.floor(b / 4), e = b % 4, f = Math.floor((b + 8) / 25), g = Math.floor((b - f + 1) / 3);
  const h = (19 * a + b - d - g + 15) % 30, i = Math.floor(c / 4), k = c % 4;
  const l = (32 + 2 * e + 2 * i - h - k) % 7, m = Math.floor((a + 11 * h + 22 * l) / 451);
  const month = Math.floor((h + l - 7 * m + 114) / 31), day = ((h + l - 7 * m + 114) % 31) + 1;
  return { m: month, d: day };
}

export type Holiday = { date: string; name: string; kind: "feriado" | "ponto_facultativo" };

export function nationalHolidays(year: number): Holiday[] {
  const p = easter(year);
  const list: Holiday[] = [
    { date: ymd(year, 1, 1), name: "Confraternização Universal", kind: "feriado" },
    { date: addDays(year, p.m, p.d, -48), name: "Carnaval (segunda)", kind: "ponto_facultativo" },
    { date: addDays(year, p.m, p.d, -47), name: "Carnaval (terça)", kind: "ponto_facultativo" },
    { date: addDays(year, p.m, p.d, -2), name: "Sexta-feira Santa", kind: "feriado" },
    { date: ymd(year, 4, 21), name: "Tiradentes", kind: "feriado" },
    { date: ymd(year, 5, 1), name: "Dia do Trabalho", kind: "feriado" },
    { date: addDays(year, p.m, p.d, 60), name: "Corpus Christi", kind: "ponto_facultativo" },
    { date: ymd(year, 9, 7), name: "Independência do Brasil", kind: "feriado" },
    { date: ymd(year, 10, 12), name: "Nossa Senhora Aparecida", kind: "feriado" },
    { date: ymd(year, 11, 2), name: "Finados", kind: "feriado" },
    { date: ymd(year, 11, 15), name: "Proclamação da República", kind: "feriado" },
    { date: ymd(year, 11, 20), name: "Dia Nacional de Zumbi e da Consciência Negra", kind: "feriado" },
    { date: ymd(year, 12, 25), name: "Natal", kind: "feriado" },
  ];
  return list.sort((a, b) => a.date.localeCompare(b.date));
}
```

## Esquemas `zod` prontos

```ts
import { z } from "zod";
import { isValidCpf, isValidCnpj, parseBrPhone, isValidCep, onlyDigits, normalizeCnpj } from "@/lib/br";

export const cpfSchema = z.string().transform(onlyDigits).refine(isValidCpf, "CPF inválido. Confira os números.");
export const cnpjSchema = z.string().transform(normalizeCnpj).refine(isValidCnpj, "CNPJ inválido. Confira os números e letras.");
export const optionalCpfSchema = z.string().transform(onlyDigits).refine((v) => v === "" || isValidCpf(v), "CPF inválido. Confira os números.");
export const phoneSchema = z.string().refine((v) => !!parseBrPhone(v), "Telefone inválido. Use DDD + número, ex.: (11) 91234-5678.");
export const cepSchema = z.string().transform(onlyDigits).refine(isValidCep, "CEP inválido. Use 8 números.");

export const clientSchema = z
  .object({
    person_type: z.enum(["pf", "pj"]),
    name: z.string().trim().min(2, "Informe o nome."),
    cpf: z.string().optional(),
    cnpj: z.string().optional(),
    phone: phoneSchema,
    is_whatsapp: z.boolean(),
    email: z.string().trim().toLowerCase().email("E-mail inválido.").or(z.literal("")),
    cep: cepSchema.or(z.literal("")),
    marketing_opt_in: z.boolean(),
  })
  .superRefine((v, ctx) => {
    if (v.person_type === "pf" && v.cpf && !isValidCpf(v.cpf))
      ctx.addIssue({ code: "custom", path: ["cpf"], message: "CPF inválido. Confira os números." });
    if (v.person_type === "pj" && !isValidCnpj(v.cnpj ?? ""))
      ctx.addIssue({ code: "custom", path: ["cnpj"], message: "CNPJ inválido. Confira os números e letras." });
  });
```

Ao salvar: `cpf: onlyDigits(v.cpf ?? "")`, `cnpj: normalizeCnpj(v.cnpj ?? "")`, `email` em minúsculas. Se `marketing_opt_in` passou de desligado para ligado, grave junto `marketing_opt_in_at: new Date().toISOString()` e o canal.

## Campo de CEP que preenche o endereço

```tsx
import { useState } from "react";
import { Input } from "@/components/ui/input";
import { Spinner } from "@/components/ui/spinner";
import { formatCep, lookupCep, onlyDigits } from "@/lib/br";

type Address = { cep: string; street: string; number: string; complement: string; district: string; city: string; state: string };

export function CepField({ value, onChange, onFound }: {
  value: string;
  onChange: (cep: string) => void;
  onFound: (a: Partial<Address>) => void;
}) {
  const [loading, setLoading] = useState(false);
  const [notFound, setNotFound] = useState(false);

  async function handle(raw: string) {
    const masked = formatCep(raw);
    onChange(onlyDigits(masked));
    setNotFound(false);
    if (onlyDigits(masked).length !== 8) return;
    setLoading(true);
    const a = await lookupCep(masked);
    setLoading(false);
    if (!a) { setNotFound(true); return; }
    onFound({ street: a.street, district: a.district, city: a.city, state: a.state });
    document.getElementById("address-number")?.focus();
  }

  return (
    <div className="min-w-0">
      <div className="relative">
        <Input inputMode="numeric" placeholder="00000-000" value={formatCep(value)} onChange={(e) => handle(e.target.value)} />
        {loading && <Spinner className="absolute top-1/2 right-3 size-4 -translate-y-1/2" />}
      </div>
      {notFound && <p className="mt-1 text-sm text-muted-foreground">Não achamos este CEP. Preencha o endereço abaixo.</p>}
    </div>
  );
}
```

O campo "Número" do formulário recebe `id="address-number"`. Rua, bairro, cidade e UF continuam editáveis depois de preenchidos.

## UFs (opções do `enum` `state`)

`AC, AL, AP, AM, BA, CE, DF, ES, GO, MA, MT, MS, MG, PA, PB, PR, PE, PI, RJ, RN, RS, RO, RR, SC, SP, SE, TO` (27).

## Exibições prontas

| Dado guardado | Função | Na tela |
|---|---|---|
| `52998224725` | `formatCpf` | 529.982.247-25 |
| `12ABC34501DE35` | `formatCnpj` | 12.ABC.345/01DE-35 |
| `+5511912345678` | `formatBrPhone` | (11) 91234-5678 |
| `+551134567890` | `formatBrPhone` | (11) 3456-7890 |
| `01310100` | `formatCep` | 01310-100 |
| `1234.56` | `formatMoney` | R$ 1.234,56 |
| `2026-10-05` | `formatDate` | 05/10/2026 |
| `2026-10-05T17:30:00Z` | `formatDateTime(v, { dateStyle: 'short', timeStyle: 'short', timeZone: 'America/Sao_Paulo' })` | 05/10/2026, 14:30 |
