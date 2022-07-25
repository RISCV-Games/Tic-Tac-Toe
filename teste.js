function lerp(r0, g0, b0, r1, g1, b1, n) {
  const result = [];
  for (let i = 0; i < n; i++) {
    const r = Math.round((r1 - r0) / (n - 1) * i + r0);
    const g = Math.round((g1 - g0) / (n - 1) * i + g0);
    const b = Math.round((b1 - b0) / (n - 1) * i + b0);

    result.push(padHex(r) + padHex(g) + padHex(b));
  }

  return result;
}

function padHex(num) {
  num = (num).toString(16);
  return num.length === 1 ? '0' + num : num;
}

console.log(lerp(0x83, 0xa5, 0x98, 0xfb, 0x49, 0x34, 6));