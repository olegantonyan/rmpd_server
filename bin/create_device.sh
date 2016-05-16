#!/bin/sh

pushd `pwd` > /dev/null

cd $(dirname $(readlink -f $0))
cd ..

if [ -z "$3" ]; then
    ENVIROMENT=production
    echo "Using default enviroment $ENVIROMENT"
else
    ENVIROMENT=$3
    echo "Using enviroment $ENVIROMENT"
fi

RAILS_ENV=$ENVIROMENT bundle exec rake device:create\["$1","$2"\]
result=$?

popd > /dev/null

exit $result
