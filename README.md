# build-glog-for-android
build glog for android with ndk


## How To

```
git clone https://github.com/google/glog/
cd glog 
git checkout  v0.3.5
cd ..

git clone https://github.com/gflags/gflags
cd gflags
git checkout v2.2.1
cd ..

## 设置NDK_ROOT, 设置SDK路径
bash build-glog.sh
```

