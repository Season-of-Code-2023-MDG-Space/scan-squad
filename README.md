#  Scrypt
[![Logo](https://i.postimg.cc/DfR9JpKx/logo-new.png)](https://postimg.cc/xqyxBR8m)

*The project is developed under the mentorship of MDG-Space Season of Code'23 IIT Roorkee*

Scrypt is a utility tool that will help in conducting online subjective exams by allowing students to scan their answer sheets in parts and merge them together as one single PDF document along with encrypted information.
###  Problem
During an online exam, many students have been observed to submit the handwritten answer images of another student in their response. These malpractices fail the actual motive of taking an exam. We provide a safe PDF scanning application that allows students to scan their answer sheets, organise the images, and create PDF files. The tool will also include features to confirm the identity of the student, specify the time and place of the picture taken as a watermark. The PDF so generated consist of mutiple QRs with information embedded within them and used for verifying the authenticity of the PDF.
### Impact
The PDF scanning tool will provide a secure and convenient way for students to complete online exams under fair conditions. By including features such as identity confirmation, watermarking, merging PDFs, and verifying PDF the tool will ensure the authenticity and validity of the answer sheets. If any issue arises in the verification process then the selected file may be forged.
### Features
- The tool encrypts metadata of each captured image using advanced encryption algorithm into the QR codes which are being embedded into a PDF file.
- For visual appearance, image data such as username, timestamp of capture, location of capture is being rendered on each page.
- User can edit, reorder pages or delete a page from the PDF being rendered.
- The tool confirms the validity of the generated PDF by scan and decode the embedded data of QRs of each page and matching the data obtained with one another.
- The generated PDF can be saved to device which can be shared easily through different apps. The homepage contains a list of generated PDFs and synced PDFs (if logged in with Google Account).
- User can upload the files to their Google Drive account for later reference.
- User can also open or delete a PDF file from the storage device.
- More functionalities to be implemented  with future updates.
 
## Getting Started

1.  Clone the repo https://github.com/Season-of-Code-2023-MDG-Space/scan-squad
2.  Download the necessary packages required by Flutter by running  `flutter pub get`.
3.  Run the application on an emulator (on Android Studio) or use a physical device (Enable USB Debugging on the device) by running the command  `flutter run`.
### Major pub.dev packages used
- firebase_auth: ^4.2.8
- firebase_core: ^2.6.1
- firebase_storage: ^11.0.15
- cloud_firestore: ^4.4.3
- image_picker: ^0.8.6+2
- image: ^3.0.1
- syncfusion_flutter_pdf: ^20.4.51
- barcode_image: ^2.0.2
- file_picker: ^5.2.5
- scan: ^1.6.0
- encrypt: ^5.0.1
- flutter_secure_storage: ^8.0.0
- googleapis: ^10.1.0
- google_sign_in: ^6.0.2
## Screenshots
![photo-2023-03-28-18-09-38.jpg](https://i.postimg.cc/pXLwb8rN/photo-2023-03-28-18-09-38.jpg)   ![photo-2023-03-28-18-09-40.jpg](https://i.postimg.cc/kgb7VZSF/photo-2023-03-28-18-09-40.jpg) [![photo-2023-03-28-18-09-24.jpg](https://i.postimg.cc/XvN32vhx/photo-2023-03-28-18-09-24.jpg)](https://postimg.cc/RWYjhvvn) [![photo-2023-03-28-18-09-34.jpg](https://i.postimg.cc/d3j4SJgm/photo-2023-03-28-18-09-34.jpg)](https://postimg.cc/Zv08WzbC) [![photo-2023-03-28-18-09-30.jpg](https://i.postimg.cc/Kv95Kpbz/photo-2023-03-28-18-09-30.jpg)](https://postimg.cc/nCDmgkCb) [![photo-2023-03-28-18-09-27.jpg](https://i.postimg.cc/7ZGS5xXs/photo-2023-03-28-18-09-27.jpg)](https://postimg.cc/HrmrK1qX) [![photo-2023-03-28-18-09-15.jpg](https://i.postimg.cc/GtfHRD0c/photo-2023-03-28-18-09-15.jpg)](https://postimg.cc/QKpXkHxP) [![photo-2023-03-28-18-09-17.jpg](https://i.postimg.cc/ydQNhR8F/photo-2023-03-28-18-09-17.jpg)](https://postimg.cc/LYPR2nfX) [![photo-2023-03-28-18-09-47.jpg](https://i.postimg.cc/YCRj2TBn/photo-2023-03-28-18-09-47.jpg)](https://postimg.cc/NKyQpJMm) [![photo-2023-03-28-18-08-51.jpg](https://i.postimg.cc/9M7W9nsj/photo-2023-03-28-18-08-51.jpg)](https://postimg.cc/HcTDDBpS)  [![photo-2023-03-28-18-08-56.jpg](https://i.postimg.cc/LXRykqb6/photo-2023-03-28-18-08-56.jpg)](https://postimg.cc/McPbqGwh) [![photo-2023-03-28-18-09-20.jpg](https://i.postimg.cc/m2wT7Mph/photo-2023-03-28-18-09-20.jpg)](https://postimg.cc/ZCWkS9Sh)

## Contributors
1. [Gaurav](https://github.com/gaurav0github)
2. [Kriti Shivhare](https://github.com/KritiShivhare)
3. [Vasu Kashiv](https://github.com/VasuKashiv)

## Made with  💙  using

![enter image description here](https://camo.githubusercontent.com/b6d2d66adc138025ea9cdf8444cdc29a588c98d062c263f8651ba6b7ad46fef0/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f466c75747465722d2532333032353639422e7376673f7374796c653d666f722d7468652d6261646765266c6f676f3d466c7574746572266c6f676f436f6c6f723d7768697465) ![enter image description here](https://camo.githubusercontent.com/a65fcdf7030d79c00f4c3d8bab84de39107f5777fca4d12f0cb64440015183fe/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f66697265626173652d2532333033394245352e7376673f7374796c653d666f722d7468652d6261646765266c6f676f3d6669726562617365)

#scan-squad
