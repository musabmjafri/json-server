cd /home/jenkins/demo/json-server/
unzip -o src.zip

cd /home/jenkins/demo/json-server/src/
if [ -f "db.json" ]; then
    echo "db.json exists"
else
    echo "Copying db.json"
    cd /home/jenkins/demo/json-server/
    mv db.json src
fi

if lsof -Pi :3000 -sTCP:LISTEN -t >/dev/null ; then
    echo "Server already listening at port 3000"
else
    cd /home/jenkins/
    mkdir ~/.npm-global
    npm config set prefix '~/.npm-global'
    export PATH=~/.npm-global/bin:$PATH
    source ~/.profile

    cd /home/jenkins/demo/json-server/src/
    sudo npm install -g json-server
    echo "Starting server"
    json-server --watch db.json --host 0.0.0.0
fi