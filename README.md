# gbt7714-2015-wordbibstyle

MS Word 可用的 GB/T 7714-2015 书目样式

# 安装

下载 [GB7714.XSL](./GB7714.XSL) 到计算机，将文件移动到 `%AppData%\Microsoft\Bibliography\Style` 目录下即可。

# 使用

打开 MS Word，在 `引用>引文与书目>样式` 中选择 `GB/T 7714 (顺序编码)`，即可应用书目样式于书目项。

# 样式效果

<p>
<style>
  ol.bib {
    conter-reset: li;
  }
  ol.bib > li {
    counter-increment: li;
  }
  ol.bib > li::marker {
    content: "[" counter(li) "] ";
  }
</style>
<ol class="bib">
  <li>Alqudsi Y., Makaraci M.. UAV swarms: research, challenges, and future directions[J]. Journal of Engineering and Applied Science, 2025, 72(1): 12.</li>
  <li>高佳宁, 刘云平, 王富尧, 程勇, 等. 基于深度强化学习的无人机集群队形保持方法[J]. 兵器装备工程学报, 2025, 46(06): 268-277</li>
</ol>
</p>

# 参考

- [国标《信息与文献 参考文献著录规则》GB/T 7714-2015.pdf](https://publishmedia.cbpt.cnki.net/portal/minio/webs/lzxb/media/web/2025/06/23/%E5%8F%82%E8%80%83%E6%96%87%E7%8C%AE%E6%A0%BC%E5%BC%8F.pdf)
- [创建自定义书目样式 | Microsoft Learn](https://learn.microsoft.com/zh-cn/office/vba/word/Concepts/Objects-Properties-Methods/create-custom-bibliography-styles)