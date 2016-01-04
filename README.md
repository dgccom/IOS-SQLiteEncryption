# IOS-SQLiteEncryption
ios sqlite加密

sqlite3开源部分是没有加密的,如果客户端需要加密,需要使用付费的.
这里使用一个开源的sqlite3文件扩展了sqlite3加密接口,用以实现sqlite3的加密功能.

本功能兼容fmdb,可与fmdb一起使用.

本功能不支持将无加密的sqlite直接加密,而是使用数据库迁移的方式进行加密.demo中带有迁移代码

使用方法详见Sqlite加解密.docx
