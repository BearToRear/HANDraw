#!/bin/bash

# Step 1: Create a React App
npx create-react-app HANDraw
cd HANDraw

# Step 2: Modify App Component (React code)
echo '
import React, { useState, useRef, useEffect } from "react";
import "./App.css";

function App() {
  const canvasRef = useRef(null);
  const [ctx, setCtx] = useState(null);
  const [isDrawing, setIsDrawing] = useState(false);
  const [brushSize, setBrushSize] = useState(5);
  const [currentColor, setCurrentColor] = useState("#000000");
  const [mirrorMode, setMirrorMode] = useState(false);

  useEffect(() => {
    const canvas = canvasRef.current;
    canvas.width = window.innerWidth * 0.8;
    canvas.height = window.innerHeight * 0.6;
    const context = canvas.getContext("2d");
    setCtx(context);
  }, []);

  const startDrawing = (e) => {
    setIsDrawing(true);
    draw(e);
  };

  const stopDrawing = () => {
    setIsDrawing(false);
    ctx.beginPath();
  };

  const draw = (e) => {
    if (!isDrawing || !ctx) return;

    const x = e.clientX || e.touches[0].clientX;
    const y = e.clientY || e.touches[0].clientY;

    ctx.lineWidth = brushSize;
    ctx.lineCap = "round";
    ctx.strokeStyle = currentColor;

    if (mirrorMode) {
      const mirrorX = canvas.width - x;
      ctx.lineTo(mirrorX, y);
      ctx.stroke();

      ctx.lineTo(x, y);
      ctx.stroke();
    } else {
      ctx.lineTo(x - canvas.offsetLeft, y - canvas.offsetTop);
      ctx.stroke();
    }

    ctx.beginPath();
    if (!mirrorMode) {
      ctx.moveTo(x - canvas.offsetLeft, y - canvas.offsetTop);
    }
  };

  const applyCanvasSize = () => {
    const canvas = canvasRef.current;
    const canvasWidth = window.innerWidth * 0.8;
    const canvasHeight = window.innerHeight * 0.6;

    canvas.width = canvasWidth;
    canvas.height = canvasHeight;

    clearCanvas();
  };

  const clearCanvas = () => {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
  };

  const downloadDrawing = () => {
    const dataUrl = canvasRef.current.toDataURL("image/png");
    const link = document.createElement("a");
    link.href = dataUrl;
    link.download = "drawing.png";
    link.click();
  };

  const updateBrushSize = (e) => {
    setBrushSize(e.target.value);
  };

  const updateColor = (e) => {
    setCurrentColor(e.target.value);
  };

  const toggleMirrorMode = () => {
    setMirrorMode(!mirrorMode);
  };

  return (
    <div className="App">
      <div className="controls">
        <div>
          <label htmlFor="brushSize">Brush Size:</label>
          <input
            type="range"
            id="brushSize"
            min="1"
            max="50"
            value={brushSize}
            onChange={updateBrushSize}
          />
        </div>

        <div>
          <label htmlFor="colorPicker">Color:</label>
          <input
            type="color"
            id="colorPicker"
            value={currentColor}
            onChange={updateColor}
          />
        </div>

        <div>
          <label htmlFor="mirrorToggle">Mirror:</label>
          <input
            type="checkbox"
            id="mirrorToggle"
            checked={mirrorMode}
            onChange={toggleMirrorMode}
          />
        </div>

        <div>
          <button onClick={applyCanvasSize}>Apply Size</button>
        </div>

        <div>
          <button onClick={clearCanvas}>Clear Canvas</button>
        </div>

        <div>
          <button onClick={downloadDrawing}>Download Drawing</button>
        </div>
      </div>

      <canvas
        ref={canvasRef}
        onMouseDown={startDrawing}
        onMouseUp={stopDrawing}
        onMouseMove={draw}
        onTouchStart={startDrawing}
        onTouchEnd={stopDrawing}
        onTouchMove={draw}
      ></canvas>
    </div>
  );
}

export default App;' > src/App.js

# Step 3: Styling (CSS code)
echo '
body {
  display: flex;
  flex-direction: column;
  align-items: center;
  font-family: "Arial", sans-serif;
}

canvas {
  border: 2px solid #000;
  margin-top: 20px;
}

.controls {
  display: flex;
  justify-content: center;
  margin-top: 20px;
}

.controls div {
  margin: 0 10px;
}

button {
  padding: 8px 16px;
  font-size: 14px;
  cursor: pointer;
}' > src/App.css

# Step 4: GitHub Pages Deployment
echo '
{
  "homepage": "https://beartorear.github.io/HANDraw",
  "scripts": {
    "predeploy": "npm run build",
    "deploy": "gh-pages -d build"
  }
}' > package.json

npm install gh-pages --save-dev
npm run deploy

# Step 5: GitHub Actions Workflow
mkdir -p .github/workflows
echo '
name: Deploy to GitHub Pages

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout Repository
      uses: actions/checkout@v2

    - name: Set up Node.js
      uses: actions/setup-node@v2
      with:
        node-version: 14

    - name: Install Dependencies
      run: npm install

    - name: Build and Deploy
      run: |
        npm run build
        npx gh-pages -d build
      env:
        CI: false
' > .github/workflows/main.yml

# Step 6: Commit Changes on GitHub Website
git add .
git commit -m "Automated setup and deployment"
git push origin main
