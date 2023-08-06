### To test the scaling, you can generate load on the WordPress deployment. There are various ways to generate load, such as using tools like Apache Benchmark (ab) or Siege. For example, you can use ab to send multiple requests to your WordPress service:

ab -n 1000 -c 50 http://<your-wordpress-service-ip>/  # Replace <your-wordpress-service-ip> with the actual IP
