/* This file auto-generated by KreMLin! */
#ifndef __Crypto_Symmetric_Cipher_H
#define __Crypto_Symmetric_Cipher_H


#include "Prims.h"
#include "FStar_Mul.h"
#include "FStar_Squash.h"
#include "FStar_StrongExcludedMiddle.h"
#include "FStar_List_Tot.h"
#include "FStar_Classical.h"
#include "FStar_ListProperties.h"
#include "FStar_SeqProperties.h"
#include "FStar_Math_Lemmas.h"
#include "FStar_BitVector.h"
#include "FStar_UInt.h"
#include "FStar_Int.h"
#include "FStar_FunctionalExtensionality.h"
#include "FStar_PropositionalExtensionality.h"
#include "FStar_PredicateExtensionality.h"
#include "FStar_TSet.h"
#include "FStar_Set.h"
#include "FStar_Map.h"
#include "FStar_Ghost.h"
#include "FStar_All.h"
#include "FStar_Bytes.h"
#include "FStar_Buffer.h"
#include "Buffer_Utils.h"
#include "Crypto_Symmetric_Bytes.h"
#include "Crypto_Symmetric_Poly1305_Spec.h"
#include "Crypto_Symmetric_Poly1305_Parameters.h"
#include "Crypto_Symmetric_Poly1305_Bigint.h"
#include "Crypto_Symmetric_Poly1305_Bignum_Lemmas_Part1.h"
#include "Crypto_Symmetric_Poly1305_Bignum_Lemmas_Part2.h"
#include "Crypto_Symmetric_Poly1305_Bignum_Lemmas_Part3.h"
#include "Crypto_Symmetric_Poly1305_Bignum_Lemmas_Part4.h"
#include "Crypto_Symmetric_Poly1305_Bignum_Lemmas_Part5.h"
#include "FStar_Buffer_Quantifiers.h"
#include "Crypto_Symmetric_Chacha20.h"
#include "Crypto_Indexing.h"
#include "Flag.h"
#include "Crypto_Symmetric_AES.h"
#include "Crypto_Symmetric_AES128.h"
#include "kremlib.h"
#include "testlib.h"

typedef Crypto_Indexing_cipherAlg Crypto_Symmetric_Cipher_alg;

uint32_t Crypto_Symmetric_Cipher_keylen(Crypto_Indexing_cipherAlg uu___41_4);

uint32_t Crypto_Symmetric_Cipher_blocklen(Crypto_Indexing_cipherAlg uu___42_23);

uint32_t Crypto_Symmetric_Cipher_ivlen(Crypto_Indexing_cipherAlg a);

uint32_t Crypto_Symmetric_Cipher_statelen(Crypto_Indexing_cipherAlg uu___43_51);

typedef uint32_t Crypto_Symmetric_Cipher_ctr;

void Crypto_Symmetric_Cipher_init(Crypto_Indexing_cipherAlg a, uint8_t *k, uint8_t *s);

void Crypto_Symmetric_Cipher_aes_store_counter(uint8_t *b, uint32_t x);

void
Crypto_Symmetric_Cipher_compute(
  Crypto_Indexing_cipherAlg a,
  uint8_t *output,
  uint8_t *st,
  FStar_UInt128_t n,
  uint32_t counter,
  uint32_t len
);
#endif
