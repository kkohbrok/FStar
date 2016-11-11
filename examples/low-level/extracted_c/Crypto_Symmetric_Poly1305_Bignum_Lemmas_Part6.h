/* This file auto-generated by KreMLin! */
#ifndef __Crypto_Symmetric_Poly1305_Bignum_Lemmas_Part6_H
#define __Crypto_Symmetric_Poly1305_Bignum_Lemmas_Part6_H


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
#include "Crypto_Symmetric_Cipher.h"
#include "Crypto_Symmetric_Poly1305_Lemmas.h"
#include "kremlib.h"
#include "testlib.h"

extern void *Crypto_Symmetric_Poly1305_Bignum_Lemmas_Part6_prime;

Prims_int Crypto_Symmetric_Poly1305_Bignum_Lemmas_Part6_w(uint32_t x0);

typedef uint64_t Crypto_Symmetric_Poly1305_Bignum_Lemmas_Part6_u26;

void
Crypto_Symmetric_Poly1305_Bignum_Lemmas_Part6_lemma_mult_le_left(
  Prims_pos a,
  Prims_nat b,
  Prims_nat c
);

void
Crypto_Symmetric_Poly1305_Bignum_Lemmas_Part6_lemma_finalize_1(
  uint64_t b0,
  uint64_t b1,
  uint64_t b2,
  uint64_t b3,
  uint64_t b4,
  uint64_t b0_,
  uint64_t b1_,
  uint64_t b2_,
  uint64_t b3_,
  uint64_t b4_,
  uint64_t mask
);

void
Crypto_Symmetric_Poly1305_Bignum_Lemmas_Part6_lemma_finalize_2(
  uint64_t b0,
  uint64_t b1,
  uint64_t b2,
  uint64_t b3,
  uint64_t b4,
  uint64_t b0_,
  uint64_t b1_,
  uint64_t b2_,
  uint64_t b3_,
  uint64_t b4_,
  uint64_t mask
);

void
Crypto_Symmetric_Poly1305_Bignum_Lemmas_Part6_lemma_finalize_3(
  uint64_t b0,
  uint64_t b1,
  uint64_t b2,
  uint64_t b3,
  uint64_t b4,
  uint64_t b0_,
  uint64_t b1_,
  uint64_t b2_,
  uint64_t b3_,
  uint64_t b4_,
  uint64_t mask
);

void
Crypto_Symmetric_Poly1305_Bignum_Lemmas_Part6_lemma_finalize_0(
  uint64_t b0,
  uint64_t b1,
  uint64_t b2,
  uint64_t b3,
  uint64_t b4,
  uint64_t b0_,
  uint64_t b1_,
  uint64_t b2_,
  uint64_t b3_,
  uint64_t b4_,
  uint64_t mask
);

void
Crypto_Symmetric_Poly1305_Bignum_Lemmas_Part6_lemma_eval_5(FStar_HyperStack_mem h, uint64_t *b);

void
Crypto_Symmetric_Poly1305_Bignum_Lemmas_Part6_lemma_norm_5(FStar_HyperStack_mem h, uint64_t *b);

void
Crypto_Symmetric_Poly1305_Bignum_Lemmas_Part6_lemma_finalize(
  FStar_HyperStack_mem h,
  uint64_t *b,
  FStar_HyperStack_mem h_,
  uint64_t *b_,
  uint64_t mask
);
#endif
