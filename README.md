# Dental Doctor App (AI-Powered Diagnosis) 🦷🧠

A **Flutter responsive application** designed for dental professionals, integrating
**Artificial Intelligence** to assist in **dental diagnosis, orthodontic analysis, and workflow management**.

The app works seamlessly on:
- 📱 Mobile
- 📟 Tablet
- 🖥️ Desktop

---

## 🧠 AI Integration

The application integrates two custom AI models:

### 1️⃣ Teeth Detection & Diagnosis – YOLOv10
- Detects individual teeth from panoramic X-ray images
- Identifies **tooth number**
- Detects dental issues such as:
  - Caries
  - Impacted teeth
  - Other visible abnormalities
- Displays bounding boxes and confidence scores directly on the X-ray

### 2️⃣ Teeth Segmentation – U-Net (Built from Scratch)
- Custom **U-Net model** built from zero
- Precisely segments tooth shapes
- Especially useful for **orthodontic analysis**
- Helps visualize tooth alignment, spacing, and crowding

---

## 🦷 AI Results Visualization
- Tooth-shaped icons representing each detected tooth
- Each icon shows:
  - Tooth number
  - Diagnosis result
- UI designed to **match AI outputs**, making results easy and fast to interpret

---

## 👨‍⚕️ Doctor Features

### 🔍 AI Diagnosis Page
- Upload panoramic X-ray images
- Run AI analysis
- Review detected teeth and diagnoses
- Edit or confirm AI results manually

### 📸 Work Portfolio
- Doctors can upload clinical cases:
  - Before treatment images
  - After treatment images
- Displayed on the doctor’s profile

### 👥 Patient Management
- View list of registered patients
- Access patients who used AI diagnosis
- Review AI-generated results for each patient
- Modify diagnosis if needed

### 📅 Appointment Management
- Organized appointment system:
  - ✅ Confirmed
  - ❌ Canceled
  - ✔️ Completed

---

## 🛠 Tech Stack
- Flutter (Responsive UI)
- Dart
- AI Models:
  - YOLOv10 (Teeth detection & diagnosis)
  - U-Net (Teeth segmentation)
- REST API integration (for AI inference)

---

## 🔒 Privacy & Medical Disclaimer
- No real patient data is included in this repository
- This system is designed to **assist**, not replace, professional medical judgment

---

## 🎓 Project Type
- Senior Graduation Project
- AI + Healthcare Application
