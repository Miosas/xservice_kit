#npm install -g xservice-arkts

rm -rf out
xservice-arkts -o out -p fleamarket.taobao.com.xservicekitexample -a -t yaml ServicesYaml


#for file in Services/*.json; do
#done


echo 'Copying oc'
cp -R out/oc/* ../ios/Runner/XService/

echo 'Copying dart'
cp -R out/dart/* ../lib/

echo 'Copying java'
cp -R out/java/  ../android/app/src/main/java/fleamarket/taobao/com/xservicekitexample

echo 'Copying arkts'
cp -R out/arkts/* ../ohos/entry/src/main/ets/

cd -
