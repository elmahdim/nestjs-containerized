FROM node:16-alpine AS development

WORKDIR /projects/src/app

COPY package*.json ./

RUN npm ci --only=development

COPY . .

RUN npm run build

FROM node:16-alpine as production

ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

WORKDIR /projects/src/app

COPY package*.json ./

RUN npm ci --only=production

COPY . .

COPY --from=development /usr/src/app/dist ./dist

EXPOSE 8080
CMD ["node", "dist/main"]