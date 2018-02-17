set -ex

curl localhost:3000/task # GET all tasks
curl localhost:3000/task -d "$(sed -e"s/xstatus/todo/" workshop.json)" # POST a task
id=$(curl localhost:3000/task | jq ".[-1].tid") # GET the last task's id
curl localhost:3000/task/$id # GET the last task
curl localhost:3000/task/$id -X PUT -d "$(sed -e"s/xstatus/done/" workshop.json)" # PUT status done to last task
curl localhost:3000/task/$id # GET the last task
curl localhost:3000/task/$id -X DELETE # DELETE the last task
curl localhost:3000/task # GET all tasks
