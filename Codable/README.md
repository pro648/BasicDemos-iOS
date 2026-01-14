###  Swift编、解码协议Codable

日常需求开发中，经常遇到调用后端服务、将数据写入磁盘，以及使用自定义模型实现app功能。在此过程中，需要将data与中间格式（JSON、Property List）来回转换。Swift提供了Encodable和Decodable协议处理数据编码、解码。通过遵守Encodable协议，可以将自定义类型编码为外部数据类型，例如JSON、Property List；反之，通过遵守Decodable协议，将外部数据类型解码为自定义模型。

![Encoding](https://raw.githubusercontent.com/pro648/tips/refs/heads/master/sources/images/26/CodableEncoding.png)

![Decoding](https://raw.githubusercontent.com/pro648/tips/refs/heads/master/sources/images/26/CodableDecoding.png)

详细介绍查看下面文章：

<https://github.com/pro648/tips/blob/master/sources/Swift编、解码协议Codable.md>

