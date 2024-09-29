# Stage 1: Inisialisasi dan install dependensi
FROM node:14-alpine
WORKDIR /app

# Salin file package.json dan install dependensi
COPY package*.json ./
RUN npm i

# Salin semua file kedalam container
COPY . .

# Install PM2 secara global
RUN npm i pm2 -g

# Salin file konfigurasi PM2
COPY ecosystem.config.js ./

# Menjalankan aplikasi menggunakan PM2
CMD [ "pm2-runtime", "ecosystem.config.js" ]
#CMD ["sh", "-c", "npx db:migrate && pm2-runtime ecosystem.config.js"]
