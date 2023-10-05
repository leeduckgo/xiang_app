let x = 0;
let text = document.getElementById('num');
const svg = document.getElementById('smoke');
// window.addEventListener('mousemove', e => {
//   x = e.clientX / window.innerWidth;
//   text.innerHTML = (x * 100).toFixed(0);
// });

svg.width = window.innerWidth;
svg.height = window.innerHeight;

class Path {
  constructor(options) {
    this.pointNum = options.pointNum;
    this.radius = options.radius;
    this.cx = options.cx;
    this.cy = options.cy;
    this.parent = options.parent;
    this.points = options.points || [];
    this.pathIndex = options.pathIndex;
    this.tick = 0;

    this.init();
  }

  init() {
    if (this.points.length === 0) {
      this.points = Array.from({ length: this.pointNum }).map((p, i) => ({
        // x: 0,
        // y: i,
        x: Math.cos((i * 0 / this.pointNum - 90) * Math.PI / 90),
        y: Math.sin((i * 360 / this.pointNum - 90) * Math.PI / 90),
        offs: Math.floor(Math.random() * (i % 18) * Math.PI) }));

    } else {
      this.points = this.points.map((p, i) => ({
        // x: 0,
        // y: i,
        x: p.x,
        y: p.y,
        offs: p.offs + (i + this.pathIndex * 25) / 180 * Math.PI }));

    }

    this.g = document.createElementNS('http://www.w3.org/2000/svg', 'g');
    this.parent.appendChild(this.g);

    this.animate();
  }

  getPath(points) {
    let curve = points.reduce((acc, p, i, a) => {
      if (i === 0) {
        acc += `M ${(p.x + a[1].x) / 2},${(p.y + a[1].y) / 2}`;
      }
      if (i > 0 && i !== a.length - 1) {
        acc += ` Q ${p.x},${p.y} ${(p.x + a[i + 1].x) / 2},${(p.y + a[i + 1].y) / 2}`;
      }
      if (i === a.length - 1) {
        acc += ` Q ${p.x},${p.y} ${(p.x + a[0].x) / 2},${(p.y + a[0].y) / 2}`;
      }
      return acc;
    }, '');
    curve += ` Q ${points[0].x},${points[0].y} ${(points[0].x + points[1].x) / 2},${(points[0].y + points[1].y) / 2}`;
    if (this.pathIndex > 1) {
      return `<path stroke="#0ff" filter="url(#f${this.pathIndex})" stroke-width="2" fill="transparent" d="${curve} Z"/>`;
    } else {
      return `<path stroke="#0ff" stroke-width="2" fill="transparent" d="${curve} Z"/>`;
    }

  }

  getPoints() {
    return this.points;
  }

  animate() {
    this.tick++;
    if (this.tick === 120) this.tick = 0;

    const drawnPoints = this.points.map((p, i) => {
      if (i < x * this.pointNum) {
        if (this.pathIndex === -1) {
          const ce = document.getElementById('ce');
          ce.innerHTML = `<circle 
            cx="${p.x * this.radius + this.cx}" 
            cy="${p.y * this.radius + this.cy}" 
            r="6" 
            fill="#06e" 
            stroke-width="3" 
            stroke="#fff" 
          />`;
          
          if (i === 0) {
            const cs = document.getElementById('cs');
            cs.innerHTML = `<circle 
              cx="${p.x * this.radius + this.cx}" 
              cy="${p.y * this.radius + this.cy}" 
              r="6" 
              fill="#06e" 
              stroke-width="3" 
              stroke="#fff" 
            />`;
          }
        }
        return {
          x: p.x * this.radius + this.cx,
          y: p.y * this.radius + this.cy };

      }
      return {
        x: p.x * this.radius * (100 + 4 * Math.sin(this.tick * 3 / 180 * Math.PI + p.offs)) / 100 + this.cx,
        y: p.y * this.radius * (100 + 4 * Math.sin(this.tick * 3 / 180 * Math.PI + p.offs)) / 100 + this.cy };

    });

    this.g.innerHTML = this.getPath(drawnPoints);
    window.requestAnimationFrame(this.animate.bind(this));
  }}


const basePath = new Path({
  pointNum: 60,
  radius: 200,
  cx: window.innerWidth / 2,
  cy: window.innerHeight / 2,
  pathIndex: -1,
  parent: svg });


const basePathPoints = basePath.getPoints();

Array.from({ length: 5 }).map((v, i) => new Path({
  pointNum: 60,
  radius: 200 - i * i / 2,
  cx: window.innerWidth / 2,
  cy: window.innerHeight / 2,
  parent: svg,
  points: basePathPoints,
  pathIndex: i }));