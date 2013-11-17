curl -0 www.garysguide.com/events -o app/views/home/garysguide.html
git add .
git commit -m "Update event list"
git push
git push heroku master
