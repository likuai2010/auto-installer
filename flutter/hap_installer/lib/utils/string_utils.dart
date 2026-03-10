/// 字符串工具函数

/// 中间省略文本
///
/// 当文本超过最大长度时，保留开头和结尾，中间用省略号替代。
///
/// [text] 原始文本
/// [maxLength] 最大显示长度（包含省略号）
///
/// 返回截断后的文本
///
/// 示例:
/// ```dart
/// truncateMiddle('my_very_long_certificate_name.cer', 24)
/// // 返回: 'my_very_lo...ame.cer'
/// ```
String truncateMiddle(String text, int maxLength) {
  if (text.length <= maxLength) return text;

  // 计算前后保留的字符数
  final available = maxLength - 3; // "..." 占 3 个字符
  if (available <= 0) return '...';

  final startLen = (available / 2).floor();
  final endLen = available - startLen;

  return '${text.substring(0, startLen)}...${text.substring(text.length - endLen)}';
}
