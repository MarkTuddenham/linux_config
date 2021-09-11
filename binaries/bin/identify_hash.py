#!/usr/bin/env python
# encoding: utf-8

# Based on:
# Hash Identifier v1.1
# By Zion3R

from typing import List
from typing import Dict
from typing import Callable

from functools import partial

algorithms = {
    "102020": "ADLER-32",
    "102040": "CRC-32",
    "102060": "CRC-32B",
    "101020": "CRC-16",
    "101040": "CRC-16-CCITT",
    "104020": "DES(Unix)",
    "101060": "FCS-16",
    "103040": "GHash-32-3",
    "103020": "GHash-32-5",
    "115060": "GOST R 34.11-94",
    "109100": "Haval-160",
    "109200": "Haval-160(HMAC)",
    "110040": "Haval-192",
    "110080": "Haval-192(HMAC)",
    "114040": "Haval-224",
    "114080": "Haval-224(HMAC)",
    "115040": "Haval-256",
    "115140": "Haval-256(HMAC)",
    "107080": "Lineage II C4",
    "106025": "Domain Cached Credentials - MD4(MD4(($pass)).(strtolower($username)))",
    "102080": "XOR-32",
    "105060": "MD5(Half)",
    "105040": "MD5(Middle)",
    "105020": "MySQL",
    "107040": "MD5(phpBB3)",
    "107060": "MD5(Unix)",
    "107020": "MD5(Wordpress)",
    "108020": "MD5(APR)",
    "106160": "Haval-128", "106165": "Haval-128(HMAC)",
    "106060": "MD2",
    "106120": "MD2(HMAC)",
    "106040": "MD4",
    "106100": "MD4(HMAC)",
    "106020": "MD5",
    "106080": "MD5(HMAC)",
    "106140": "MD5(HMAC(Wordpress))",
    "106029": "NTLM",
    "106027": "RAdmin v2.x",
    "106180": "RipeMD-128",
    "106185": "RipeMD-128(HMAC)",
    "106200": "SNEFRU-128",
    "106205": "SNEFRU-128(HMAC)",
    "106220": "Tiger-128",
    "106225": "Tiger-128(HMAC)",
    "106240": "md5($pass.$salt)",
    "106260": "md5($salt.'-'.md5($pass))",
    "106280": "md5($salt.$pass)",
    "106300": "md5($salt.$pass.$salt)",
    "106320": "md5($salt.$pass.$username)",
    "106340": "md5($salt.md5($pass))",
    "106360": "md5($salt.md5($pass).$salt)",
    "106380": "md5($salt.md5($pass.$salt))",
    "106400": "md5($salt.md5($salt.$pass))",
    "106420": "md5($salt.md5(md5($pass).$salt))",
    "106440": "md5($username.0.$pass)",
    "106460": "md5($username.LF.$pass)",
    "106480": "md5($username.md5($pass).$salt)",
    "106500": "md5(md5($pass))",
    "106520": "md5(md5($pass).$salt)",
    "106540": "md5(md5($pass).md5($salt))",
    "106560": "md5(md5($salt).$pass)",
    "106580": "md5(md5($salt).md5($pass))",
    "106600": "md5(md5($username.$pass).$salt)",
    "106620": "md5(md5(md5($pass)))",
    "106640": "md5(md5(md5(md5($pass))))",
    "106660": "md5(md5(md5(md5(md5($pass)))))",
    "106680": "md5(sha1($pass))",
    "106700": "md5(sha1(md5($pass)))",
    "106720": "md5(sha1(md5(sha1($pass))))",
    "106740": "md5(strtoupper(md5($pass)))",
    "109040": "MySQL5 - SHA-1(SHA-1($pass))",
    "109060": "MySQL 160bit - SHA-1(SHA-1($pass))",
    "109180": "RipeMD-160(HMAC)",
    "109120": "RipeMD-160",
    "109020": "SHA-1",
    "109140": "SHA-1(HMAC)",
    "109220": "SHA-1(MaNGOS)",
    "109240": "SHA-1(MaNGOS2)",
    "109080": "Tiger-160",
    "109160": "Tiger-160(HMAC)",
    "109260": "sha1($pass.$salt)",
    "109280": "sha1($salt.$pass)",
    "109300": "sha1($salt.md5($pass))",
    "109320": "sha1($salt.md5($pass).$salt)",
    "109340": "sha1($salt.sha1($pass))",
    "109360": "sha1($salt.sha1($salt.sha1($pass)))",
    "109380": "sha1($username.$pass)",
    "109400": "sha1($username.$pass.$salt)",
    "1094202": "sha1(md5($pass))",
    "109440": "sha1(md5($pass).$salt)",
    "109460": "sha1(md5(sha1($pass)))",
    "109480": "sha1(sha1($pass))",
    "109500": "sha1(sha1($pass).$salt)",
    "109520": "sha1(sha1($pass).substr($pass, 0, 3))",
    "109540": "sha1(sha1($salt.$pass))",
    "109560": "sha1(sha1(sha1($pass)))",
    "109580": "sha1(strtolower($username).$pass)",
    "110020": "Tiger-192",
    "110060": "Tiger-192(HMAC)",
    "112020": "md5($pass.$salt) - Joomla",
    "113020": "SHA-1(Django)",
    "114020": "SHA-224",
    "114060": "SHA-224(HMAC)",
    "115080": "RipeMD-256",
    "115160": "RipeMD-256(HMAC)",
    "115100": "SNEFRU-256",
    "115180": "SNEFRU-256(HMAC)",
    "115200": "SHA-256(md5($pass))",
    "115220": "SHA-256(sha1($pass))",
    "115020": "SHA-256",
    "115120": "SHA-256(HMAC)",
    "116020": "md5($pass.$salt) - Joomla",
    "116040": "SAM - (LM_hash:NT_hash)",
    "117020": "SHA-256(Django)",
    "118020": "RipeMD-320",
    "118040": "RipeMD-320(HMAC)",
    "119020": "SHA-384",
    "119040": "SHA-384(HMAC)",
    "120020": "SHA-256",
    "121020": "SHA-384(Django)",
    "122020": "SHA-512",
    "122060": "SHA-512(HMAC)",
    "122040": "Whirlpool",
    "122080": "Whirlpool(HMAC)"
}

checks: Dict[str, Callable[[str], bool]] = {
    'lower': str.islower,
    'digit': str.isdigit,
    'alpha': str.isalpha,
    'alnum': str.isalnum,
}


# === Helpers ===
def compatible(hash: str, length: int, **kwargs) -> bool:
    fits: bool = True
    for k, v in kwargs.items():
        fits &= checks[k](hash) is v
    return fits and len(hash) == length


def check_hash(hash: str, hash_list: List[str], ex_hash: str, alg_code: str, **kwargs):
    if compatible(hash, len(ex_hash), **kwargs):
        hash_list.append(alg_code)
# === /Helpers ===


def MySQL160bit(hash: str, hash_list: List[str]) -> None:
    hs = '*2470c0c06dee42fd1618bb99005adca2ec9d1e19'
    if (
       len(hash) == len(hs)
       and hash.isdigit() is False
       and hash.isalpha() is False
       and hash.isalnum() is False
       and hash[0:1].find('*') == 0):
        hash_list.append("109060")


def MD5passsaltjoomla1(hash: str, hash_list: List[str]) -> None:
    hs = '35d1c0d69a2df62be2df13b087343dc9:BeKMviAfcXeTPTlX'
    if (
       len(hash) == len(hs)
       and hash.isdigit() is False
       and hash.isalpha() is False
       and hash.isalnum() is False
       and hash[32:33].find(':') == 0):
        hash_list.append("112020")


def SHA1Django(hash: str, hash_list: List[str]) -> None:
    hs = 'sha1$Zion3R$299c3d65a0dcab1fc38421783d64d0ecf4113448'
    if (
       len(hash) == len(hs)
       and hash.isdigit() is False
       and hash.isalpha() is False
       and hash.isalnum() is False
       and hash[0:5].find('sha1$') == 0):
        hash_list.append("113020")


def MD5passsaltjoomla2(hash: str, hash_list: List[str]) -> None:
    hs = 'fb33e01e4f8787dc8beb93dac4107209:fxJUXVjYRafVauT77Cze8XwFrWaeAYB2'
    if (
       len(hash) == len(hs)
       and hash.isdigit() is False
       and hash.isalpha() is False
       and hash.isalnum() is False
       and hash[32:33].find(':') == 0):
        hash_list.append("116020")


def SAM(hash: str, hash_list: List[str]) -> None:
    hs = '4318B176C3D8E3DEAAD3B435B51404EE:B7C899154197E8A2A33121D76A240AB5'
    if (
       len(hash) == len(hs)
       and hash.isdigit() is False
       and hash.isalpha() is False
       and hash.isalnum() is False
       and hash.islower() is False
       and hash[32:33].find(':') == 0):
        hash_list.append("116040")


def SHA256Django(hash: str, hash_list: List[str]) -> None:
    hs = 'sha256$Zion3R$9e1a08aa28a22dfff722fad7517bae68a55444bb5e2f909d340767cec9acf2c3'
    if (
       len(hash) == len(hs)
       and hash.isdigit() is False
       and hash.isalpha() is False
       and hash.isalnum() is False
       and hash[0:6].find('sha256') == 0):
        hash_list.append("117020")


def SHA256s(hash: str, hash_list: List[str]) -> None:
    hs = ('$6$g4TpUQzk$OmsZBJFwvy6MwZckPvVYfDnwsgktm2CckOlNJGy9HNwHS'
          'uHFvywGIuwkJ6Bjn3kKbB6zoyEjIYNMpHWBNxJ6g.')
    if (
       len(hash) == len(hs)
       and hash.isdigit() is False
       and hash.isalpha() is False
       and hash.isalnum() is False
       and hash[0:3].find('$6$') == 0):
        hash_list.append("120020")


def SHA384Django(hash: str, hash_list: List[str]) -> None:
    hs = ('sha384$Zion3R$88cfd5bc332a4af9f09aa33a1593f24eddc01de00b84'
          '395765193c3887f4deac46dc723ac14ddeb4d3a9b958816b7bba')
    if (
       len(hash) == len(hs)
       and hash.isdigit() is False
       and hash.isalpha() is False
       and hash.isalnum() is False
       and hash[0:6].find('sha384') == 0):
        print(" [+] SHA-384(Django)")
        hash_list.append("121020")


def LineageIIC4(hash: str, hash_list: List[str]) -> None:
    hs = '0x49a57f66bd3d5ba6abda5579c264a0e4'
    if (
       len(hash) == len(hs)
       and hash.isdigit() is False
       and hash.isalpha() is False
       and hash.isalnum() is True
       and hash[0:2].find('0x') == 0):
        hash_list.append("107080")


def MD5phpBB3(hash: str, hash_list: List[str]) -> None:
    hs = '$H$9kyOtE8CDqMJ44yfn9PFz2E.L2oVzL1'
    if (
       len(hash) == len(hs)
       and hash.isdigit() is False
       and hash.isalpha() is False
       and hash.isalnum() is False
       and hash[0:3].find('$H$') == 0):
        hash_list.append("107040")


def MD5Unix(hash: str, hash_list: List[str]) -> None:
    hs = '$1$cTuJH0Ju$1J8rI.mJReeMvpKUZbSlY/'
    if (
       len(hash) == len(hs)
       and hash.isdigit() is False
       and hash.isalpha() is False
       and hash.isalnum() is False
       and hash[0:3].find('$1$') == 0):
        hash_list.append("107060")


def MD5Wordpress(hash: str, hash_list: List[str]) -> None:
    hs = '$P$BiTOhOj3ukMgCci2juN0HRbCdDRqeh.'
    if (
       len(hash) == len(hs)
       and hash.isdigit() is False
       and hash.isalpha() is False
       and hash.isalnum() is False
       and hash[0:3].find('$P$') == 0):
        hash_list.append("107020")


def MD5APR(hash: str, hash_list: List[str]) -> None:
    hs = '$apr1$qAUKoKlG$3LuCncByN76eLxZAh/Ldr1'
    if len(hash) == len(hs) and hash.isdigit() is False and hash.isalpha() is False and hash[
            0: 4].find('$apr') == 0:
        hash_list.append("108020")


# pylint: disable=line-too-long
hash_checkers: Dict[str, Callable[[str, List[str]], None]] = {
    'CRC16': partial(check_hash, ex_hash='4607', alg_code='101020', alpha=False, alnum=True),  # noqa: E501
    'CRC16CCITT': partial(check_hash, ex_hash='3d08', alg_code='101040', alpha=False, alnum=True),  # noqa: E501
    'FCS16': partial(check_hash, ex_hash='0e5b', alg_code='101060', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'CRC32': partial(check_hash, ex_hash='b33fd057', alg_code='102040', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'ADLER32': partial(check_hash, ex_hash='0607cb42', alg_code='102020', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'CRC32B': partial(check_hash, ex_hash='b764a0d9', alg_code='102060', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'XOR32': partial(check_hash, ex_hash='0000003f', alg_code='102080', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'GHash323': partial(check_hash, ex_hash='80000000', alg_code='103040', isdigit=True, alpha=False, alnum=True),  # noqa: E501
    'GHash325': partial(check_hash, ex_hash='85318985', alg_code='103020', isdigit=True, alpha=False, alnum=True),  # noqa: E501
    'DESUnix': partial(check_hash, ex_hash='ZiY8YtDKXJwYQ', alg_code='104020', isdigit=False, alpha=False),  # noqa: E501
    'MD5Half': partial(check_hash, ex_hash='ae11fd697ec92c7c', alg_code='105060', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'MD5Middle': partial(check_hash, ex_hash='7ec92c7c98de3fac', alg_code='105040', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'MySQL': partial(check_hash, ex_hash='63cea4673fd25f46', alg_code='105020', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'DomainCachedCredentials': partial(check_hash, ex_hash='f42005ec1afe77967cbc83dce1b4d714', alg_code='106025', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'Haval128': partial(check_hash, ex_hash='d6e3ec49aa0f138a619f27609022df10', alg_code='106160', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'Haval128HMAC': partial(check_hash, ex_hash='3ce8b0ffd75bc240fc7d967729cd6637', alg_code='106165', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'MD2': partial(check_hash, ex_hash='08bbef4754d98806c373f2cd7d9a43c4', alg_code='106060', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'MD2HMAC': partial(check_hash, ex_hash='4b61b72ead2b0eb0fa3b8a56556a6dca', alg_code='106120', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'MD4': partial(check_hash, ex_hash='a2acde400e61410e79dacbdfc3413151', alg_code='106040', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'MD4HMAC': partial(check_hash, ex_hash='6be20b66f2211fe937294c1c95d1cd4f', alg_code='106100', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'MD5': partial(check_hash, ex_hash='ae11fd697ec92c7c98de3fac23aba525', alg_code='106020', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'MD5HMAC': partial(check_hash, ex_hash='d57e43d2c7e397bf788f66541d6fdef9', alg_code='106080', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'MD5HMACWordpress': partial(check_hash, ex_hash='3f47886719268dfa83468630948228f6', alg_code='106140', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'NTLM': partial(check_hash, ex_hash='cc348bace876ea440a28ddaeb9fd3550', alg_code='106029', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'RAdminv2x': partial(check_hash, ex_hash='baea31c728cbf0cd548476aa687add4b', alg_code='106027', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'RipeMD128': partial(check_hash, ex_hash='4985351cd74aff0abc5a75a0c8a54115', alg_code='106180', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'RipeMD128HMAC': partial(check_hash, ex_hash='ae1995b931cf4cbcf1ac6fbf1a83d1d3', alg_code='106185', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'SNEFRU128': partial(check_hash, ex_hash='4fb58702b617ac4f7ca87ec77b93da8a', alg_code='106200', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'SNEFRU128HMAC': partial(check_hash, ex_hash='59b2b9dcc7a9a7d089cecf1b83520350', alg_code='106205', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'Tiger128': partial(check_hash, ex_hash='c086184486ec6388ff81ec9f23528727', alg_code='106220', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'Tiger128HMAC': partial(check_hash, ex_hash='c87032009e7c4b2ea27eb6f99723454b', alg_code='106225', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'md5passsalt': partial(check_hash, ex_hash='5634cc3b922578434d6e9342ff5913f7', alg_code='106240', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'md5saltdashmd5pass': partial(check_hash, ex_hash='245c5763b95ba42d4b02d44bbcd916f1', alg_code='106260', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'md5saltpass': partial(check_hash, ex_hash='22cc5ce1a1ef747cd3fa06106c148dfa', alg_code='106280', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'md5saltpasssalt': partial(check_hash, ex_hash='469e9cdcaff745460595a7a386c4db0c', alg_code='106300', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'md5saltpassusername': partial(check_hash, ex_hash='9ae20f88189f6e3a62711608ddb6f5fd', alg_code='106320', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'md5saltmd5pass': partial(check_hash, ex_hash='aca2a052962b2564027ee62933d2382f', alg_code='106340', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'md5saltmd5passsalt': partial(check_hash, ex_hash='de0237dc03a8efdf6552fbe7788b2fdd', alg_code='106360', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'md5saltmd5saltpass': partial(check_hash, ex_hash='d8f3b3f004d387086aae24326b575b23', alg_code='106400', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'md5saltmd5md5passsalt': partial(check_hash, ex_hash='81f181454e23319779b03d74d062b1a2', alg_code='106420', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'md5username0pass': partial(check_hash, ex_hash='e44a60f8f2106492ae16581c91edb3ba', alg_code='106440', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'md5usernameLFpass': partial(check_hash, ex_hash='654741780db415732eaee12b1b909119', alg_code='106460', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'md5usernamemd5passsalt': partial(check_hash, ex_hash='954ac5505fd1843bbb97d1b2cda0b98f', alg_code='106480', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'md5md5pass': partial(check_hash, ex_hash='a96103d267d024583d5565436e52dfb3', alg_code='106500', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'md5md5passsalt': partial(check_hash, ex_hash='5848c73c2482d3c2c7b6af134ed8dd89', alg_code='106520', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'md5md5passmd5salt': partial(check_hash, ex_hash='8dc71ef37197b2edba02d48c30217b32', alg_code='106540', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'md5md5saltpass': partial(check_hash, ex_hash='9032fabd905e273b9ceb1e124631bd67', alg_code='106560', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'md5md5saltmd5pass': partial(check_hash, ex_hash='8966f37dbb4aca377a71a9d3d09cd1ac', alg_code='106580', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'md5md5usernamepasssalt': partial(check_hash, ex_hash='4319a3befce729b34c3105dbc29d0c40', alg_code='106600', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'md5md5md5pass': partial(check_hash, ex_hash='ea086739755920e732d0f4d8c1b6ad8d', alg_code='106620', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'md5md5md5md5pass': partial(check_hash, ex_hash='02528c1f2ed8ac7d83fe76f3cf1c133f', alg_code='106640', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'md5md5md5md5md5pass': partial(check_hash, ex_hash='4548d2c062933dff53928fd4ae427fc0', alg_code='106660', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'md5sha1pass': partial(check_hash, ex_hash='cb4ebaaedfd536d965c452d9569a6b1e', alg_code='106680', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'md5sha1md5pass': partial(check_hash, ex_hash='099b8a59795e07c334a696a10c0ebce0', alg_code='106700', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'md5sha1md5sha1pass': partial(check_hash, ex_hash='06e4af76833da7cc138d90602ef80070', alg_code='106720', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'md5strtouppermd5pass': partial(check_hash, ex_hash='519de146f1a658ab5e5e2aa9b7d2eec8', alg_code='106740', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'Haval160': partial(check_hash, ex_hash='a106e921284dd69dad06192a4411ec32fce83dbb', alg_code='109100', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'Haval160HMAC': partial(check_hash, ex_hash='29206f83edc1d6c3f680ff11276ec20642881243', alg_code='109200', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'MySQL5': partial(check_hash, ex_hash='9bb2fb57063821c762cc009f7584ddae9da431ff', alg_code='109040', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'RipeMD160': partial(check_hash, ex_hash='dc65552812c66997ea7320ddfb51f5625d74721b', alg_code='109120', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'RipeMD160HMAC': partial(check_hash, ex_hash='ca28af47653b4f21e96c1235984cb50229331359', alg_code='109180', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'SHA1': partial(check_hash, ex_hash='4a1d4dbc1e193ec3ab2e9213876ceb8f4db72333', alg_code='109020', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'SHA1HMAC': partial(check_hash, ex_hash='6f5daac3fee96ba1382a09b1ba326ca73dccf9e7', alg_code='109140', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'SHA1MaNGOS': partial(check_hash, ex_hash='a2c0cdb6d1ebd1b9f85c6e25e0f8732e88f02f96', alg_code='109220', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'SHA1MaNGOS2': partial(check_hash, ex_hash='644a29679136e09d0bd99dfd9e8c5be84108b5fd', alg_code='109240', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'Tiger160': partial(check_hash, ex_hash='c086184486ec6388ff81ec9f235287270429b225', alg_code='109080', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'Tiger160HMAC': partial(check_hash, ex_hash='6603161719da5e56e1866e4f61f79496334e6a10', alg_code='109160', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'sha1passsalt': partial(check_hash, ex_hash='f006a1863663c21c541c8d600355abfeeaadb5e4', alg_code='109260', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'sha1saltpass': partial(check_hash, ex_hash='299c3d65a0dcab1fc38421783d64d0ecf4113448', alg_code='109280', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'sha1saltmd5pass': partial(check_hash, ex_hash='860465ede0625deebb4fbbedcb0db9dc65faec30', alg_code='109300', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'sha1saltmd5passsalt': partial(check_hash, ex_hash='6716d047c98c25a9c2cc54ee6134c73e6315a0ff', alg_code='109320', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'sha1saltsha1pass': partial(check_hash, ex_hash='58714327f9407097c64032a2fd5bff3a260cb85f', alg_code='109340', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'sha1saltsha1saltsha1pass': partial(check_hash, ex_hash='cc600a2903130c945aa178396910135cc7f93c63', alg_code='109360', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'sha1usernamepass': partial(check_hash, ex_hash='3de3d8093bf04b8eb5f595bc2da3f37358522c9f', alg_code='109380', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'sha1usernamepasssalt': partial(check_hash, ex_hash='00025111b3c4d0ac1635558ce2393f77e94770c5', alg_code='109400', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'sha1md5pass': partial(check_hash, ex_hash='fa960056c0dea57de94776d3759fb555a15cae87', alg_code='1094202', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'sha1md5passsalt': partial(check_hash, ex_hash='1dad2b71432d83312e61d25aeb627593295bcc9a', alg_code='109440', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'sha1md5sha1pass': partial(check_hash, ex_hash='8bceaeed74c17571c15cdb9494e992db3c263695', alg_code='109460', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'sha1sha1pass': partial(check_hash, ex_hash='3109b810188fcde0900f9907d2ebcaa10277d10e', alg_code='109480', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'sha1sha1passsalt': partial(check_hash, ex_hash='780d43fa11693b61875321b6b54905ee488d7760', alg_code='109500', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'sha1sha1passsubstrpass03': partial(check_hash, ex_hash='5ed6bc680b59c580db4a38df307bd4621759324e', alg_code='109520', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'sha1sha1saltpass': partial(check_hash, ex_hash='70506bac605485b4143ca114cbd4a3580d76a413', alg_code='109540', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'sha1sha1sha1pass': partial(check_hash, ex_hash='3328ee2a3b4bf41805bd6aab8e894a992fa91549', alg_code='109560', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'sha1strtolowerusernamepass': partial(check_hash, ex_hash='79f575543061e158c2da3799f999eb7c95261f07', alg_code='109580', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'Haval192': partial(check_hash, ex_hash='cd3a90a3bebd3fa6b6797eba5dab8441f16a7dfa96c6e641', alg_code='110040', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'Haval192HMAC': partial(check_hash, ex_hash='39b4d8ecf70534e2fd86bb04a877d01dbf9387e640366029', alg_code='110080', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'Tiger192': partial(check_hash, ex_hash='c086184486ec6388ff81ec9f235287270429b2253b248a70', alg_code='110020', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'Tiger192HMAC': partial(check_hash, ex_hash='8e914bb64353d4d29ab680e693272d0bd38023afa3943a41', alg_code='110060', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'Haval224': partial(check_hash, ex_hash='f65d3c0ef6c56f4c74ea884815414c24dbf0195635b550f47eac651a', alg_code='114040', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'Haval224HMAC': partial(check_hash, ex_hash='f10de2518a9f7aed5cf09b455112114d18487f0c894e349c3c76a681', alg_code='114080', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'SHA224': partial(check_hash, ex_hash='e301f414993d5ec2bd1d780688d37fe41512f8b57f6923d054ef8e59', alg_code='114020', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'SHA224HMAC': partial(check_hash, ex_hash='c15ff86a859892b5e95cdfd50af17d05268824a6c9caaa54e4bf1514', alg_code='114060', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'SHA256': partial(check_hash, ex_hash='2c740d20dab7f14ec30510a11f8fd78b82bc3a711abe8a993acdb323e78e6d5e', alg_code='115020', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'SHA256HMAC': partial(check_hash, ex_hash='d3dd251b7668b8b6c12e639c681e88f2c9b81105ef41caccb25fcde7673a1132', alg_code='115120', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'Haval256': partial(check_hash, ex_hash='7169ecae19a5cd729f6e9574228b8b3c91699175324e6222dec569d4281d4a4a', alg_code='115040', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'Haval256HMAC': partial(check_hash, ex_hash='6aa856a2cfd349fb4ee781749d2d92a1ba2d38866e337a4a1db907654d4d4d7a', alg_code='115140', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'GOSTR341194': partial(check_hash, ex_hash='ab709d384cce5fda0793becd3da0cb6a926c86a8f3460efb471adddee1c63793', alg_code='115060', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'RipeMD256': partial(check_hash, ex_hash='5fcbe06df20ce8ee16e92542e591bdea706fbdc2442aecbf42c223f4461a12af', alg_code='115080', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'RipeMD256HMAC': partial(check_hash, ex_hash='43227322be1b8d743e004c628e0042184f1288f27c13155412f08beeee0e54bf', alg_code='115160', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'SNEFRU256': partial(check_hash, ex_hash='3a654de48e8d6b669258b2d33fe6fb179356083eed6ff67e27c5ebfa4d9732bb', alg_code='115100', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'SNEFRU256HMAC': partial(check_hash, ex_hash='4e9418436e301a488f675c9508a2d518d8f8f99e966136f2dd7e308b194d74f9', alg_code='115180', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'SHA256md5pass': partial(check_hash, ex_hash='b419557099cfa18a86d1d693e2b3b3e979e7a5aba361d9c4ec585a1a70c7bde4', alg_code='115200', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'SHA256sha1pass': partial(check_hash, ex_hash='afbed6e0c79338dbfe0000efe6b8e74e3b7121fe73c383ae22f5b505cb39c886', alg_code='115220', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'RipeMD320': partial(check_hash, ex_hash='b4f7c8993a389eac4f421b9b3b2bfb3a241d05949324a8dab1286069a18de69aaf5ecc3c2009d8ef', alg_code='118020', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'RipeMD320HMAC': partial(check_hash, ex_hash='244516688f8ad7dd625836c0d0bfc3a888854f7c0161f01de81351f61e98807dcd55b39ffe5d7a78', alg_code='118040', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'SHA384': partial(check_hash, ex_hash='3b21c44f8d830fa55ee9328a7713c6aad548fe6d7a4a438723a0da67c48c485220081a2fbc3e8c17fd9bd65f8d4b4e6b', alg_code='119020', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'SHA384HMAC': partial(check_hash, ex_hash='bef0dd791e814d28b4115eb6924a10beb53da47d463171fe8e63f68207521a4171219bb91d0580bca37b0f96fddeeb8b', alg_code='119040', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'SHA512': partial(check_hash, ex_hash='ea8e6f0935b34e2e6573b89c0856c81b831ef2cadfdee9f44eb9aa0955155ba5e8dd97f85c73f030666846773c91404fb0e12fb38936c56f8cf38a33ac89a24e', alg_code='122020', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'SHA512HMAC': partial(check_hash, ex_hash='dd0ada8693250b31d9f44f3ec2d4a106003a6ce67eaa92e384b356d1b4ef6d66a818d47c1f3a2c6e8a9a9b9bdbd28d485e06161ccd0f528c8bbb5541c3fef36f', alg_code='122060', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'Whirlpool': partial(check_hash, ex_hash='76df96157e632410998ad7f823d82930f79a96578acc8ac5ce1bfc34346cf64b4610aefa8a549da3f0c1da36dad314927cebf8ca6f3fcd0649d363c5a370dddb', alg_code='122040', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'WhirlpoolHMAC': partial(check_hash, ex_hash='77996016cf6111e97d6ad31484bab1bf7de7b7ee64aebbc243e650a75a2f9256cef104e504d3cf29405888fca5a231fcac85d36cd614b1d52fce850b53ddf7f9', alg_code='122080', isdigit=False, alpha=False, alnum=True),  # noqa: E501
    'MySQL160bit': MySQL160bit,
    'MD5passsaltjoomla1': MD5passsaltjoomla1,
    'SHA1Django': SHA1Django,
    'MD5passsaltjoomla2': MD5passsaltjoomla2,
    'SAM': SAM,
    'SHA256Django': SHA256Django,
    'SHA256s': SHA256s,
    'SHA384Django': SHA384Django,
    'LineageIIC4': LineageIIC4,
    'MD5phpBB3': MD5phpBB3,
    'MD5Unix': MD5Unix,
    'MD5Wordpress': MD5Wordpress,
    'MD5APR': MD5APR,
}
# pylint: enable=line-too-long

if __name__ == '__main__':
    while True:
        hash_list: List[str] = []
        # TODO dont use this, take hashes as inputs args
        hash = input(" Enter Hash: ")

        for _, checker in hash_checkers.items():
            checker(hash, hash_list)

        if len(hash_list) == 0:
            print("")
            print(" No matches found.")
        elif len(hash_list) > 2:
            hash_list.sort()
            print("")
            print("Possible Hashes:")
            print("[+] ", algorithms[hash_list[0]])
            print("[+] ", algorithms[hash_list[1]])
            print("")
            print("Least Possible Hashes:")
            for a in range(int(len(hash_list)) - 2):
                print("[+] ", algorithms[hash_list[a + 2]])
        else:
            hash_list.sort()
            print("")
            print("Possible Hashes:")
            for a in range(len(hash_list)):
                print("[+] ", algorithms[hash_list[a]])
