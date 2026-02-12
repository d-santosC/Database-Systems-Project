# 🚗 Rent-a-Car Management System  
### Database Systems – Web Application (JSP + MySQL)
### Sistemas de Bases de Dados – ISEL

This project consists of a full-stack web application integrated with a relational database for managing a "Rent-a-Car" company.

It supports multiple user roles and implements transactional and analytical operations over a structured SQL database.

---

## 📌 Project Overview

The system was developed in two main phases:

1. Database modeling & implementation  
2. Web application integration using JSP + JDBC  

The final result is a role-based web platform that allows managing:

- Clients  
- Vehicles  
- Reservations  
- Drivers  
- Rentals  
- Rankings & Analytics  
- Import/Export (JSON & XML)  

---

## 🧠 Database Design

The database schema was refined and improved during development, including:

- Updated Entity-Relationship Model  
- Updated Relational Model  
- Primary and Foreign Key adjustments  
- Addition of new entities (`Reservas`, `Ativos`)  

### Main Tables

- `Cliente`
- `Veiculo`
- `TipoVeiculo`
- `Condutor`
- `Aluguer`
- `Reservas`
- `Ativos`

The system ensures:

- Referential integrity  
- Transactional consistency  
- Structured role-based access  

---

## 👥 User Roles & Functionalities

### 🛠 Administrator
- Manage clients  
- Manage vehicles  
- Import/Export JSON data  
- Full database control  

### 👤 Client
- Reserve vehicles  
- Select vehicle type & model  
- Choose parking location  
- Apply discount coupons  
- View reservation status  

### 🚘 Driver (Condutor)
- Pick up vehicles  
- Deliver vehicles  
- Register kilometers  
- Leave optional feedback  

### 👨‍💼 Employee (Funcionário)
- Assign vehicles to reservations  
- Locate vehicles in parking lots  
- Register vehicle interventions  
- Access client records  
- Check client reputation  

### 👔 Manager (Gerente)
- View vehicle history  
- Access performance rankings  
- Analyze usage data  

---

## 🛠 Technologies Used

- Java (JDK 21)
- JavaServer Pages (JSP)
- JDBC
- MySQL Server
- MySQL Workbench
- Apache Tomcat
- JSON Library
- Eclipse IDE (Enterprise Edition)

---

## 🔄 Data Import & Export

The system supports:

- JSON import/export  
- XML data handling  
- Image storage using `LONGBLOB`  

---

## 🏗 Architecture Highlights

- Multi-role access system  
- Separation between business logic and database  
- JDBC-based SQL interaction  
- Referential integrity enforcement  
- Transactional rental management  

---

## 📈 What I Learned

- Designing and evolving relational schemas  
- Managing complex foreign key dependencies  
- Building multi-role systems  
- Integrating JSP with SQL databases  
- Handling structured data import/export  
- Developing transactional and analytical features  

---

## 🔮 Possible Improvements

- Secure authentication system  
- Password encryption  
- REST API layer  
- Modern frontend framework  
- Dockerized deployment  
- Cloud hosting  

---
