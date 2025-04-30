server {
    charset utf-8;
    client_max_body_size 128M;

    listen 80;
    server_name {{ domain_name }};

    root /var/www/basic/web;
    index index.php;

    access_log /var/log/nginx/yii2-access.log;
    error_log /var/log/nginx/yii2-error.log;

    location / {
        # Redirect everything that isn't a real file to index.php
        try_files $uri $uri/ /index.php$is_args$args;
    }

    # uncomment to avoid processing of calls to non-existing static files by Yii
    #location ~ \.(js|css|png|jpg|gif|swf|ico|pdf|mov|fla|zip|rar)$ {
    #    try_files $uri =404;
    #}
    #error_page 404 /404.html;

    # deny accessing php files for the /assets directory
    location ~ ^/assets/.*\.php$ {
        deny all;
    }

    location ~ \.php$ {
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_pass app:9000;  # Points to the 'app' service in docker-compose
        try_files $uri =404;
    }

    location ~* /\. {
        deny all;
    }
}
