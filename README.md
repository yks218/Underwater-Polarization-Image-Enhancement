# Underwater Polarization Image Enhancement

##  Project Overview
This project implements a physics-based underwater image enhancement method using polarization imaging.

The method leverages Stokes vector theory and polarization-based image decomposition to estimate background scattering and recover degraded underwater images.

---

##  Key Idea

1. Capture polarization images at different angles (0°, 45°, 90°, 135°)
2. Compute Stokes parameters (S0, S1, S2)
3. Estimate Degree of Polarization (DoP)
4. Separate background scattering using polarization characteristics
5. Estimate transmission map based on physical degradation model
6. Recover enhanced underwater image

---

- Polarization-based scattering separation
- Physics-driven transmission estimation
- Adaptive background light estimation
- Frequency-domain filtering enhancement
- Region-based correction for better reconstruction

---

##  Project Structure
underwater-polarization-enhancement/
│
├── main_underwater.m # Entry point
├── compute_underwater.m # Core algorithm
├── config.m # Parameters
│
├── utils/
│ ├── h_generate_2d.m
│ ├── mse.m
│ ├── psnr.m
│ ├── ssim.m
│ ├── imblizoom.m
│
├── data/
│ └── sample/
│ ├── 0.bmp
│ ├── 45.bmp
│ ├── 90.bmp
│ ├── 135.bmp
│ ├── raw.bmp
│
├── results/
│ └── result.png


---

## How to Run

1. Open MATLAB
2. Set working directory:

```matlab
cd underwater-polarization-enhancement
3. Run:
main_underwater

Evaluation Metrics
PSNR (Peak Signal-to-Noise Ratio)
SSIM (Structural Similarity)
MSE (Mean Squared Error)
Contrast Enhancement Measure (EME)

Notes
Sample data is provided for demonstration only
You can replace images in data/sample/ with your own dataset
Parameters can be adjusted in config.m