# IOS-SQLiteEncryption

ios sqlite加密

sqlite3开源部分是没有加密的,如果客户端需要加密,需要使用付费的.
这里使用一个开源的sqlite3文件扩展了sqlite3加密接口,用以实现sqlite3的加密功能.

本功能兼容fmdb,可与fmdb一起使用.

本功能不支持将无加密的sqlite直接加密,而是使用数据库迁移的方式进行加密.demo中带有迁移代码.

在调用open方法之后调用setkey方法,便可将数据库解密,如果是新建的数据库,此方法便是给sqlite设置一个密码,在close sqlite之前都可以正常执行sql

在工程的build setting里修改配置other c flags添加-DSQLITE_HAS_CODEC -DSQKUTE_THREADSAFE -DSQLCIPHER_CRYPTO_CC -DSQLITE_TEMP_STORE=2,加入Security.framework


安卓和PHP参考 https://www.zetetic.net/sqlcipher/documentation/

特别致谢：https://www.zetetic.net/sqlcipher/
