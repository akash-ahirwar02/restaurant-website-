FROM nginx:alpine

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

COPY . /usr/share/nginx/html

RUN chown -R appuser:appgroup /usr/share/nginx/html

EXPOSE 80

USER appuser

CMD ["nginx", "-g", "daemon off;"]
