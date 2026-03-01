# Web3 & Blockchain Security Reference

คู่มือความปลอดภัย Web3 และ Blockchain — OWASP Smart Contract Top 10 2026,
Smart Contract Audit, DeFi Security Patterns, Wallet & Key Management

> สำหรับ code security analysis (SAST/DAST) → ดู references/code-security-analysis.md (Domain 6)
> สำหรับ supply chain security → ดู references/container-supply-chain.md (Domain 7)
> สำหรับ vulnerability management → ดู references/vulnerability-management.md (Domain 14)
> สำหรับ end-to-end integration → ดู references/cross-domain-integration.md (Domain 16)
> สำหรับ post-quantum crypto implications → ดู references/post-quantum-cryptography.md (Domain 20)

**Cross-references:**

- Domain 6: Code Security Analysis → `references/code-security-analysis.md`
- Domain 7: Container & Supply Chain → `references/container-supply-chain.md`
- Domain 14: Vulnerability Management → `references/vulnerability-management.md`
- Domain 16: Cross-Domain Integration → `references/cross-domain-integration.md`
- Domain 20: Post-Quantum Cryptography → `references/post-quantum-cryptography.md`

## Table of Contents

1. Web3 Security Landscape (incl. Post-Quantum Impact on Blockchain)
2. OWASP Smart Contract Top 10 2026
3. Smart Contract Audit Methodology
4. DeFi Security Patterns
5. Wallet & Key Management
6. Bridge & Cross-chain Security
7. Security Tools
8. Thai Context (บริบทประเทศไทย)
9. Web3 Security Checklist

---

## Quick Reference (สรุปย่อ)

> ใช้ section นี้สำหรับตอบคำถามเร็ว — deep-dive ดู sections ด้านล่าง

**Frameworks:** OWASP Smart Contract Top 10 2026 | Ethereum Security Best Practices

**OWASP Smart Contract Top 10 2026:**

| ID   | Risk                           | Severity |
| ---- | ------------------------------ | -------- |
| SC01 | Access Control Vulnerabilities | Critical |
| SC02 | Business Logic Vulnerabilities | Critical |
| SC03 | Price Oracle Manipulation      | Critical |
| SC04 | Flash Loan–Facilitated Attacks | Critical |
| SC05 | Lack of Input Validation       | High     |
| SC06 | Unchecked External Calls       | High     |
| SC07 | Arithmetic Errors              | High     |
| SC08 | Reentrancy Attacks             | Critical |
| SC09 | Integer Overflow and Underflow | High     |
| SC10 | Denial of Service (Gas Limit)  | Medium   |

**Attack Stats:** $2.36B losses in 2024 (760+ incidents), avg $3.1M per incident

**Essential Controls:**

- Multi-sig wallets (Gnosis Safe) + hardware signing สำหรับ treasury
- Professional audit (Slither + Mythril + manual review) ก่อน deploy
- Time-lock + pause mechanisms สำหรับ upgradeable contracts
- Price oracle: Chainlink + TWAP + deviation checks
- Reentrancy guard (OpenZeppelin ReentrancyGuard) ทุก external call

**Thai Context:** ก.ล.ต. digital asset regulations, Travel Rule FATF (transfers >= 1,000 USD), BoT stablecoin oversight

---

## 1. ภูมิทัศน์ความปลอดภัย Web3 (Web3 Security Landscape)

### Web3 Attack Statistics (2024-2025)

| Year | Total Losses (USD) | Number of Incidents | Avg Loss per Incident | Funds Recovered |
| ---- | ------------------ | ------------------- | --------------------- | --------------- |
| 2024 | $2.36 billion      | 760+                | $3.1 million          | ~$488 million   |
| 2025 | $1.78 billion\*    | 580+\*              | $3.07 million         | ~$320 million   |

\*2025 figures through Q3 — ข้อมูลบางส่วนอาจยังไม่ครบปี

### DeFi vs CeFi Attack Distribution

```
Attack Value Distribution (2024-2025)
┌────────────────────────────────────────────────────────────────┐
│                                                                │
│  DeFi Protocols   ████████████████████████████████  59%        │
│  CeFi Exchanges   ████████████████                  28%        │
│  Bridge Exploits  ██████                             8%        │
│  NFT / GameFi     ███                                5%        │
│                                                                │
└────────────────────────────────────────────────────────────────┘

Top Attack Vectors by Value Lost:
1. Private Key Compromise     $890M  ██████████████████████
2. Smart Contract Exploits    $720M  ██████████████████
3. Flash Loan Attacks         $380M  █████████
4. Rug Pulls / Exit Scams     $290M  ███████
5. Bridge Exploits            $240M  ██████
6. Oracle Manipulation        $180M  ████
7. Phishing / Social Eng.     $160M  ████
8. Governance Attacks         $95M   ██
```

### Web3 Attack Taxonomy

```
Web3 Attack Surface
├── Smart Contract Layer
│   ├── Reentrancy — เรียก function ซ้ำก่อน state update เสร็จ
│   ├── Access control — เรียก privileged functions โดยไม่มีสิทธิ์
│   ├── Integer overflow/underflow — คำนวณผิดพลาดจาก arithmetic errors
│   ├── Logic errors — ข้อผิดพลาดใน business logic (lending, AMM, governance)
│   ├── Flash loan exploits — ใช้ uncollateralized loans ขยายผล bug เล็กๆ
│   └── Proxy/upgrade bugs — misconfigured upgradeable proxy patterns
│
├── Protocol Layer
│   ├── Oracle manipulation — บิดเบือนราคาผ่าน low-liquidity pools
│   ├── MEV / sandwich attacks — front-run transactions เพื่อดึงกำไร
│   ├── Governance attacks — ซื้อ voting power ด้วย flash loan
│   ├── Bridge exploits — โจมตี cross-chain message verification
│   └── Consensus attacks — 51% attacks บน smaller chains
│
├── Key Management Layer
│   ├── Private key theft — ขโมย keys จาก hot wallets, compromised servers
│   ├── Seed phrase phishing — หลอกให้ผู้ใช้กรอก seed phrase
│   ├── Multi-sig compromise — compromise signers ให้ครบ threshold
│   └── Social engineering — โจมตี key holders ด้วย social engineering
│
└── Application Layer (dApp)
    ├── Front-end compromise — inject malicious code ใน dApp UI
    ├── DNS hijacking — เปลี่ยน DNS ชี้ไป phishing site
    ├── Supply chain attacks — compromise npm/pip dependencies ของ dApp
    └── Approval phishing — หลอกให้ approve token spending ไม่จำกัด
```

### Web3 Security Maturity Model

| Level | ระดับ                          | คำอธิบาย                                                    | ตัวบ่งชี้ (Indicators)                                     |
| ----- | ------------------------------ | ----------------------------------------------------------- | ---------------------------------------------------------- |
| 0     | ไม่มี (Ad hoc)                 | ไม่มี security process, deploy โดยไม่ audit                 | No audits, no monitoring, no incident response             |
| 1     | เริ่มต้น (Initial)             | มี basic testing, ใช้ automated tools บ้าง                  | Slither/Aderyn scans, basic unit tests                     |
| 2     | กำหนดรูปแบบ (Defined)          | มี audit process, severity classification, basic monitoring | External audit before mainnet, OpenZeppelin Defender       |
| 3     | จัดการ (Managed)               | มี formal verification, bug bounty, on-chain monitoring     | Certora specs, Immunefi program, Forta bots                |
| 4     | ปรับปรุงต่อเนื่อง (Optimizing) | มี comprehensive security program, proactive threat hunting | Red team exercises, MEV protection, cross-chain monitoring |

### Post-Quantum Impact on Blockchain (ผลกระทบ Post-Quantum ต่อ Blockchain)

> Cross-reference: ดู Domain 20 `references/post-quantum-cryptography.md` สำหรับ PQC standards เชิงลึก

Blockchain ทั้งหมดพึ่งพา elliptic curve cryptography (ECDSA, EdDSA) สำหรับ transaction signing
และ key derivation — quantum computer ที่มี qubit เพียงพอ (CRQC) จะทำลายได้ทั้งหมด:

**Algorithms ที่ถูกคุกคาม:**

| Algorithm               | ใช้ใน                        | Quantum Attack                             | Timeline                                |
| ----------------------- | ---------------------------- | ------------------------------------------ | --------------------------------------- |
| ECDSA P-256 / secp256k1 | Ethereum, Bitcoin tx signing | Shor's algorithm breaks in polynomial time | 2028-2035                               |
| EdDSA (Ed25519)         | Solana, Cosmos, Polkadot     | Shor's algorithm                           | 2028-2035                               |
| SHA-256 (mining)        | Bitcoin PoW                  | Grover's (quadratic speedup only)          | Low risk — double key length sufficient |
| Keccak-256 (hashing)    | Ethereum state/storage       | Grover's (quadratic speedup only)          | Low risk                                |

**ความเสี่ยงเฉพาะ Blockchain:**

1. **"Harvest Now, Decrypt Later" (HNDL):** transactions บน public blockchain เป็น permanent record —
   adversary สามารถเก็บ public keys วันนี้ แล้วใช้ quantum computer crack private keys ในอนาคต
2. **Address reuse vulnerability:** Ethereum addresses ที่ส่ง transaction แล้ว expose public key
   ทำให้เป็นเป้าหมายตรงของ quantum attack (addresses ที่ยังไม่เคยส่งปลอดภัยกว่า — ซ่อน public key ไว้หลัง hash)
3. **Smart contract immutability:** contracts ที่ verify ECDSA signatures on-chain จะไม่สามารถ upgrade ได้
   ถ้าไม่มี proxy pattern — ต้องวางแผน migration path ล่วงหน้า
4. **DeFi total value locked:** มูลค่า >$100B ใน DeFi protocols ที่ protected ด้วย ECDSA —
   quantum break จะเป็น systemic risk ระดับ ecosystem

**Migration Path (แนวทางการ migrate):**

| Phase        | Timeline  | Action                                                                                         |
| ------------ | --------- | ---------------------------------------------------------------------------------------------- |
| 1. Inventory | ตอนนี้    | สำรวจ contracts ที่ใช้ ECDSA verification, จำนวน addresses ที่ exposed public key              |
| 2. Research  | 2025-2027 | ติดตาม EIP proposals สำหรับ PQC (EIP-7702 account abstraction, quantum-safe signature schemes) |
| 3. Hybrid    | 2027-2030 | Deploy contracts ที่รองรับทั้ง ECDSA + PQC signatures (ML-DSA), ใช้ account abstraction        |
| 4. Migration | 2030-2035 | Migrate ทุก wallet/contract ไป PQC-only, phase out ECDSA verification                          |

**Ethereum-specific PQC Considerations:**

- **EIP-7702** (Account Abstraction) ช่วยให้ EOA upgrade signature scheme ได้โดยไม่ต้องเปลี่ยน address
- **Hash-based signatures** (XMSS, LMS) เป็น alternative ที่ quantum-safe แต่มี state management complexity
- **Gas cost:** PQC signatures (ML-DSA) มีขนาดใหญ่กว่า ECDSA ~10-50x → gas cost สูงขึ้นมาก
- **Bitcoin:** Taproot (BIP-341) เตรียม path สำหรับ future signature scheme upgrades

---

## 2. OWASP Smart Contract Top 10 2026

### Risk Overview

| Rank | ID   | Risk Name                              | Likelihood | Impact   | Priority |
| ---- | ---- | -------------------------------------- | ---------- | -------- | -------- |
| 1    | SC01 | Access Control Vulnerabilities         | High       | Critical | P0       |
| 2    | SC02 | Business Logic Vulnerabilities         | High       | Critical | P0       |
| 3    | SC03 | Price Oracle Manipulation              | Medium     | Critical | P0       |
| 4    | SC04 | Flash Loan–Facilitated Attacks         | Medium     | Critical | P1       |
| 5    | SC05 | Lack of Input Validation               | High       | High     | P1       |
| 6    | SC06 | Unchecked External Calls               | Medium     | High     | P1       |
| 7    | SC07 | Arithmetic Errors                      | Medium     | High     | P1       |
| 8    | SC08 | Reentrancy Attacks                     | Low        | Critical | P2       |
| 9    | SC09 | Integer Overflow and Underflow         | Low        | High     | P2       |
| 10   | SC10 | Proxy & Upgradeability Vulnerabilities | Medium     | High     | P1       |

### Comparison: 2025 → 2026 Edition

| Change  | Risk                       | 2025 Rank | 2026 Rank | หมายเหตุ                                               |
| ------- | -------------------------- | --------- | --------- | ------------------------------------------------------ |
| —       | Access Control             | #1        | #1        | ยังคงเป็นอันดับ 1 — ช่องโหว่ที่พบบ่อยที่สุด            |
| RENAMED | Business Logic             | #3\*      | #2        | เปลี่ยนชื่อจาก Logic Errors, ขึ้นมา #2                 |
| —       | Price Oracle Manipulation  | #2        | #3        | ลดลงเล็กน้อย — TWAP adoption เพิ่มขึ้น                 |
| ROSE    | Flash Loan Attacks         | #7        | #4        | ขึ้นจาก #7 → #4 — attacks ซับซ้อนขึ้นมาก               |
| —       | Lack of Input Validation   | #5        | #5        | คงที่                                                  |
| —       | Unchecked External Calls   | #6        | #6        | คงที่                                                  |
| —       | Arithmetic Errors          | #4        | #7        | ลดลง — Solidity 0.8+ built-in overflow checks          |
| DROPPED | Reentrancy                 | #5\*      | #8        | ลงจาก #5 → #8 — CEI pattern และ transient storage      |
| MERGED  | Integer Overflow/Underflow | #9\*      | #9        | ยังอยู่แต่ลด likelihood — Solidity 0.8+ default checks |
| NEW     | Proxy & Upgradeability     | —         | #10       | ใหม่ — เพิ่มเนื่องจาก upgrade-related exploits เพิ่ม   |
| DROPPED | Insecure Randomness        | #8        | —         | ถูกตัดออก — Chainlink VRF แก้ปัญหาส่วนใหญ่แล้ว         |
| DROPPED | Denial of Service          | #10       | —         | ถูกตัดออก — gas limit protections เพียงพอ              |

### SC01: Access Control Vulnerabilities

- **คำอธิบาย**: ผู้โจมตีเรียก privileged functions ที่ควรจำกัดเฉพาะ owner/admin ได้ เนื่องจากขาด access control modifier หรือ logic ผิดพลาด ทำให้เปลี่ยน state variables สำคัญ เช่น withdraw funds, change ownership, pause protocol

- **ตัวอย่างโจมตี (Solidity)**:

```solidity
// VULNERABLE — ไม่มี access control
contract VulnerableVault {
    address public owner;

    // ไม่มี modifier ตรวจสอบสิทธิ์ — ใครก็เรียกได้
    function setOwner(address _newOwner) external {
        owner = _newOwner;  // ผู้โจมตีเปลี่ยน owner ได้เลย
    }

    function withdrawAll() external {
        // ไม่ตรวจสอบว่าผู้เรียกเป็น owner หรือไม่
        payable(msg.sender).transfer(address(this).balance);
    }
}
```

- **แนวทางแก้ไข (Mitigation)**:

```solidity
// SECURE — ใช้ OpenZeppelin AccessControl
import "@openzeppelin/contracts/access/AccessControl.sol";

contract SecureVault is AccessControl {
    bytes32 public constant WITHDRAWER_ROLE = keccak256("WITHDRAWER_ROLE");

    constructor() {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(WITHDRAWER_ROLE, msg.sender);
    }

    function withdrawAll() external onlyRole(WITHDRAWER_ROLE) {
        payable(msg.sender).transfer(address(this).balance);
    }
}
```

### SC02: Business Logic Vulnerabilities

- **คำอธิบาย**: ข้อผิดพลาดระดับ design ใน business logic ของ protocol เช่น lending rate calculation ผิด, AMM invariant ไม่ถูกต้อง, reward distribution ไม่สมดุล, governance voting logic มีช่องโหว่ — ทำให้ผู้โจมตีดึง value ออกจาก protocol ได้

- **ตัวอย่างโจมตี (Solidity)**:

```solidity
// VULNERABLE — reward calculation ไม่คำนึงถึง time-weighted stake
contract VulnerableStaking {
    mapping(address => uint256) public stakedAmount;
    uint256 public totalRewards;
    uint256 public totalStaked;

    function claimReward() external {
        // Bug: คำนวณ reward จาก snapshot เดียว ไม่คำนึงถึงระยะเวลา stake
        // ผู้โจมตี stake จำนวนมากก่อน claim แล้วถอนทันที
        uint256 reward = (stakedAmount[msg.sender] * totalRewards) / totalStaked;
        payable(msg.sender).transfer(reward);
    }
}
```

- **แนวทางแก้ไข**: ใช้ time-weighted reward calculation, มี staking cooldown period, ทำ economic modeling และ simulation ก่อน deploy, ใช้ established patterns เช่น Synthetix StakingRewards

### SC03: Price Oracle Manipulation

- **คำอธิบาย**: ผู้โจมตีบิดเบือน price feed ที่ protocol ใช้อ้างอิง — มักโจมตี spot price จาก DEX ที่มี liquidity ต่ำ ส่งผลให้ lending protocol ปล่อยกู้เกินมูลค่า หรือ liquidation เกิดขึ้นผิดพลาด

- **ตัวอย่างโจมตี (Solidity)**:

```solidity
// VULNERABLE — ใช้ spot price จาก single DEX pool
contract VulnerableLending {
    IUniswapV2Pair public pair;

    function getPrice() public view returns (uint256) {
        // Spot price — สามารถบิดเบือนได้ด้วย flash loan
        (uint112 reserve0, uint112 reserve1,) = pair.getReserves();
        return (uint256(reserve1) * 1e18) / uint256(reserve0);
    }

    function borrow(uint256 collateralAmount) external {
        uint256 price = getPrice();  // ราคาที่ถูก manipulate
        uint256 borrowLimit = (collateralAmount * price) / 1e18;
        // ปล่อยกู้ตาม manipulated price...
    }
}
```

- **แนวทางแก้ไข**: ใช้ Chainlink Price Feeds (decentralized oracle network), ใช้ TWAP (Time-Weighted Average Price) แทน spot price, ตั้ง price deviation threshold, ใช้ multiple oracle sources

### SC04: Flash Loan–Facilitated Attacks

- **คำอธิบาย**: Flash loans ให้ผู้โจมตียืมเงินจำนวนมหาศาลโดยไม่ต้องวางหลักประกัน (ต้องคืนภายใน transaction เดียว) — ใช้เป็นตัวขยายผล (amplifier) ของ bugs เล็กๆ ให้กลายเป็น large-scale drains

- **ตัวอย่างโจมตี (Solidity)**:

```solidity
// ตัวอย่าง flash loan attack flow
contract FlashLoanAttacker {
    function attack() external {
        // 1. ยืม 100M USDC ผ่าน flash loan (ไม่ต้องวาง collateral)
        flashLender.flashLoan(address(this), 100_000_000e6);
    }

    function onFlashLoan(uint256 amount) external {
        // 2. ใช้ 100M USDC ทุ่มซื้อ TOKEN_A ใน low-liquidity pool
        //    → ราคา TOKEN_A พุ่งขึ้น 10x (manipulated)
        dex.swap(USDC, TOKEN_A, amount);

        // 3. ใช้ TOKEN_A ที่ราคาสูง (manipulated) เป็น collateral
        //    กู้ออกมาได้มากกว่าปกติ
        lending.depositCollateral(TOKEN_A, tokenABalance);
        lending.borrow(USDC, inflatedBorrowAmount);

        // 4. คืน flash loan + เก็บกำไร
        USDC.transfer(address(flashLender), amount + fee);
        // profit = inflatedBorrowAmount - amount - fee
    }
}
```

- **แนวทางแก้ไข**: ใช้ TWAP oracle แทน spot price, ป้องกัน same-block interactions (delay mechanism), ใช้ Chainlink VRF สำหรับ randomness, ตรวจสอบ flash loan detection patterns

### SC05: Lack of Input Validation

- **คำอธิบาย**: ไม่ validate input parameters ที่ผู้ใช้ส่งมา เช่น zero address, overflow amounts, ช่วงค่าที่ไม่ถูกต้อง — ส่งผลให้ contract ทำงานผิดพลาดหรือ drain funds ได้

- **ตัวอย่างโจมตี (Solidity)**:

```solidity
// VULNERABLE — ไม่ตรวจสอบ input
contract VulnerableToken {
    function transfer(address to, uint256 amount) external {
        // ไม่ตรวจว่า to != address(0) → token หายถาวร
        // ไม่ตรวจว่า amount > 0 → waste gas
        // ไม่ตรวจว่า balance เพียงพอ
        balances[msg.sender] -= amount;
        balances[to] += amount;
    }
}

// SECURE — validate ทุก input
contract SecureToken {
    function transfer(address to, uint256 amount) external {
        require(to != address(0), "Transfer to zero address");
        require(amount > 0, "Amount must be positive");
        require(balances[msg.sender] >= amount, "Insufficient balance");

        balances[msg.sender] -= amount;
        balances[to] += amount;
        emit Transfer(msg.sender, to, amount);
    }
}
```

### SC06: Unchecked External Calls

- **คำอธิบาย**: การเรียก external contract โดยไม่ตรวจสอบ return value หรือไม่จัดการ failure — ทำให้ contract ทำงานต่อแม้ external call ล้มเหลว อาจเกิดสถานะ inconsistent

- **ตัวอย่างโจมตี (Solidity)**:

```solidity
// VULNERABLE — ไม่ตรวจ return value ของ low-level call
contract VulnerablePayment {
    function pay(address payable recipient, uint256 amount) external {
        // low-level call ไม่ revert เมื่อ fail — return false แทน
        recipient.call{value: amount}("");  // return value ถูกเพิกเฉย!
        // code ทำงานต่อแม้ transfer ล้มเหลว
        balances[msg.sender] -= amount;  // state update แม้ payment fail
    }
}

// SECURE — ตรวจ return value
contract SecurePayment {
    function pay(address payable recipient, uint256 amount) external {
        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Payment failed");
        balances[msg.sender] -= amount;
    }
}
```

### SC07: Arithmetic Errors

- **คำอธิบาย**: ข้อผิดพลาดจากการคำนวณ เช่น division precision loss, rounding errors ใน token exchange rates, incorrect scaling ระหว่าง decimals ต่างกัน — แม้ Solidity 0.8+ จะมี overflow protection แล้ว แต่ logic errors ยังเกิดได้

- **ตัวอย่างโจมตี (Solidity)**:

```solidity
// VULNERABLE — precision loss จาก division ก่อน multiplication
contract VulnerableExchange {
    function calculateShares(uint256 deposit, uint256 totalDeposits,
                             uint256 totalShares) public pure returns (uint256) {
        // Bug: division ก่อน multiplication → precision loss
        // ถ้า deposit = 99, totalDeposits = 100 → 99/100 = 0 (integer division)
        return (deposit / totalDeposits) * totalShares;  // = 0 shares!
    }
}

// SECURE — multiplication ก่อน division
contract SecureExchange {
    function calculateShares(uint256 deposit, uint256 totalDeposits,
                             uint256 totalShares) public pure returns (uint256) {
        return (deposit * totalShares) / totalDeposits;  // ถูกต้อง
    }
}
```

### SC08: Reentrancy Attacks

- **คำอธิบาย**: External call สามารถ callback เข้ามา function ที่กำลังทำงานอยู่ก่อนที่ state จะ update — ผู้โจมตีใช้เรียกซ้ำ (re-enter) เพื่อดึง funds ออกหลายรอบ เป็นช่องโหว่ที่เลื่องชื่อที่สุดใน Ethereum (DAO hack 2016, $60M)

- **คำอธิบาย 2026**: Reentrancy ลดลงจาก #5 → #8 เนื่องจาก Checks-Effects-Interactions pattern แพร่หลาย, ReentrancyGuard ใน OpenZeppelin, และ EIP-1153 transient storage ใน Dencun upgrade

- **ตัวอย่างโจมตี (Solidity)**:

```solidity
// VULNERABLE — state update หลัง external call
contract VulnerableVault {
    mapping(address => uint256) public balances;

    function withdraw() external {
        uint256 amount = balances[msg.sender];
        // External call ก่อน state update — reentrancy!
        (bool success,) = msg.sender.call{value: amount}("");
        require(success);
        balances[msg.sender] = 0;  // state update มาทีหลัง!
    }
}

// Attacker contract
contract Attacker {
    VulnerableVault vault;

    receive() external payable {
        if (address(vault).balance >= 1 ether) {
            vault.withdraw();  // re-enter ก่อน balance = 0
        }
    }
}
```

- **แนวทางแก้ไข (CEI Pattern + ReentrancyGuard)**:

```solidity
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract SecureVault is ReentrancyGuard {
    mapping(address => uint256) public balances;

    function withdraw() external nonReentrant {
        uint256 amount = balances[msg.sender];
        require(amount > 0, "No balance");

        // Checks-Effects-Interactions (CEI) pattern:
        // 1. Checks — ตรวจสอบเงื่อนไข (done above)
        // 2. Effects — update state ก่อน
        balances[msg.sender] = 0;
        // 3. Interactions — external call ทีหลัง
        (bool success,) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");
    }
}
```

### SC09: Integer Overflow and Underflow

- **คำอธิบาย**: ใน Solidity < 0.8.0 integer overflow/underflow ไม่ revert — ค่า wrap around เงียบๆ ใน Solidity 0.8+ มี built-in checks แล้ว แต่ `unchecked` blocks และ assembly ยังเสี่ยงอยู่

- **ตัวอย่างโจมตี (Solidity)**:

```solidity
// VULNERABLE (Solidity < 0.8.0 หรือใน unchecked block)
contract VulnerableToken {
    mapping(address => uint256) public balances;

    function transfer(address to, uint256 amount) external {
        unchecked {
            // ถ้า balances[msg.sender] = 0, amount = 1
            // → 0 - 1 = 2^256 - 1 (underflow!) → balance กลายเป็นเลขมหาศาล
            balances[msg.sender] -= amount;
            balances[to] += amount;
        }
    }
}

// SECURE — ใช้ Solidity 0.8+ default checks (ไม่ต้อง unchecked)
// pragma solidity ^0.8.0;
contract SecureToken {
    mapping(address => uint256) public balances;

    function transfer(address to, uint256 amount) external {
        // Solidity 0.8+ จะ revert อัตโนมัติถ้า underflow
        balances[msg.sender] -= amount;
        balances[to] += amount;
    }
}
```

### SC10: Proxy & Upgradeability Vulnerabilities

- **คำอธิบาย**: ข้อผิดพลาดใน proxy pattern ที่ใช้ upgrade contracts — เช่น uninitialized implementation, storage collision ระหว่าง proxy กับ implementation, missing upgrade authorization, selfdestruct ใน implementation contract

- **ตัวอย่างโจมตี (Solidity)**:

```solidity
// VULNERABLE — implementation ไม่ initialized
// ผู้โจมตีเรียก initialize() บน implementation contract โดยตรง
// แล้ว selfdestruct → ทำให้ proxy ชี้ไป destroyed contract
contract VulnerableImplementation {
    address public owner;
    bool public initialized;

    // ไม่ป้องกันการเรียกซ้ำ — ไม่มี initializer modifier
    function initialize(address _owner) external {
        owner = _owner;
        initialized = true;
    }

    function destroy() external {
        require(msg.sender == owner);
        selfdestruct(payable(owner));  // DANGEROUS on implementation!
    }
}

// SECURE — ใช้ OpenZeppelin UUPS หรือ Transparent Proxy
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract SecureImplementation is Initializable, UUPSUpgradeable {
    address public owner;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();  // ป้องกัน initialize บน implementation
    }

    function initialize(address _owner) public initializer {
        owner = _owner;
    }

    function _authorizeUpgrade(address) internal override {
        require(msg.sender == owner, "Not authorized");
    }
}
```

---

## 3. แนวทางการ Audit Smart Contract (Smart Contract Audit Methodology)

### Pre-Audit Checklist

- [ ] Source code ครบถ้วนและ compile ได้ (Solidity version ระบุชัดเจน)
- [ ] มี documentation อธิบาย architecture, flows, assumptions
- [ ] มี test suite พร้อม coverage report (ควร > 90%)
- [ ] ระบุ scope ชัดเจน — contracts ไหนอยู่ใน scope
- [ ] ระบุ external dependencies (OpenZeppelin version, oracle addresses)
- [ ] ระบุ deployment chain(s) — Ethereum, Polygon, Arbitrum, etc.
- [ ] Previous audit reports (ถ้ามี) พร้อม remediation status
- [ ] Known risks / accepted trade-offs documented

### Audit Phases

```
Smart Contract Audit Workflow
┌─────────────────────────────────────────────────────────┐
│                                                         │
│  Phase 1: Automated Scanning (Day 1-2)                  │
│  ├── Slither static analysis                            │
│  ├── Aderyn AST analysis                                │
│  ├── Mythril symbolic execution                         │
│  └── Custom detector rules                              │
│           │                                             │
│           ▼                                             │
│  Phase 2: Manual Review (Day 3-8)                       │
│  ├── Architecture review — ตรวจ design patterns         │
│  ├── Line-by-line code review — ตรวจทุกบรรทัด           │
│  ├── Access control analysis — ตรวจ privilege flow      │
│  ├── Economic analysis — ตรวจ incentive alignment       │
│  ├── Cross-contract interaction — ตรวจ composability    │
│  └── Edge case analysis — ตรวจ boundary conditions      │
│           │                                             │
│           ▼                                             │
│  Phase 3: Formal Verification (Day 7-10)                │
│  ├── Certora rule specs — mathematical proofs           │
│  ├── Echidna property tests — invariant fuzzing         │
│  ├── Foundry fuzz tests — custom fuzz campaigns         │
│  └── Symbolic execution — Manticore deep analysis       │
│           │                                             │
│           ▼                                             │
│  Phase 4: Report & Remediation (Day 9-12)               │
│  ├── Draft report — findings + severity + PoC           │
│  ├── Team review — discuss with dev team                │
│  ├── Fix verification — re-audit remediated code        │
│  └── Final report — publish audit report                │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### Severity Classification

| Severity          | คำอธิบาย                                                    | CVSS Range | Response Time |
| ----------------- | ----------------------------------------------------------- | ---------- | ------------- |
| **Critical**      | ผู้โจมตีดึง funds ออกได้โดยตรง, drain protocol ทั้งหมด      | 9.0-10.0   | ต้องแก้ทันที  |
| **High**          | สูญเสีย funds ภายใต้เงื่อนไขบางอย่าง, access control bypass | 7.0-8.9    | ก่อน deploy   |
| **Medium**        | ส่งผลกระทบจำกัด, ต้องการเงื่อนไขซับซ้อน                     | 4.0-6.9    | ก่อน deploy   |
| **Low**           | ผลกระทบน้อย, best practice violations                       | 0.1-3.9    | ควรแก้ไข      |
| **Informational** | ไม่ใช่ vulnerability แต่เป็น suggestions, gas optimization  | N/A        | แนะนำ         |

### Audit Report Template

```markdown
# Smart Contract Security Audit Report

**Project**: [Project Name]
**Version**: [Commit Hash / Tag]
**Audit Firm**: [Firm Name]
**Audit Period**: [Start Date] — [End Date]
**Auditors**: [Names]

## Executive Summary

[2-3 paragraphs: scope, methodology, key findings summary, overall risk rating]

| Severity      | Count | Fixed | Acknowledged | Open |
| ------------- | ----- | ----- | ------------ | ---- |
| Critical      | [n]   | [n]   | [n]          | [n]  |
| High          | [n]   | [n]   | [n]          | [n]  |
| Medium        | [n]   | [n]   | [n]          | [n]  |
| Low           | [n]   | [n]   | [n]          | [n]  |
| Informational | [n]   | [n]   | [n]          | [n]  |

## Scope

| Contract           | SLOC | Complexity |
| ------------------ | ---- | ---------- |
| [ContractName].sol | [n]  | [H/M/L]    |

## Findings

### [F-01] [Finding Title]

**Severity**: Critical
**Status**: Fixed (commit [hash])
**File**: [path/to/file.sol]
**Lines**: [L123-L145]

**Description**:
[รายละเอียดช่องโหว่เป็น Thai + English technical terms]

**Proof of Concept**:
[Foundry test หรือ transaction sequence ที่ reproduce ได้]

**Recommendation**:
[แนวทางแก้ไขพร้อม code example]

**Team Response**:
[Developer's response and fix description]
```

### Common Audit Findings Taxonomy

| Category             | ตัวอย่าง Findings                                                 | ความถี่ |
| -------------------- | ----------------------------------------------------------------- | ------- |
| Access Control       | Missing onlyOwner, incorrect role checks, unprotected initialize  | สูงมาก  |
| Reentrancy           | Cross-function reentrancy, read-only reentrancy                   | ปานกลาง |
| Oracle Issues        | Spot price usage, stale price, missing heartbeat check            | สูง     |
| Input Validation     | Zero address, zero amount, out-of-range parameters                | สูงมาก  |
| Logic Errors         | Wrong formula, missing edge case, incorrect state transitions     | สูง     |
| Upgrade Issues       | Uninitialized impl, storage collision, missing gap                | ปานกลาง |
| Gas Optimization     | Unnecessary storage reads, loop optimization, packing             | สูงมาก  |
| Event Emissions      | Missing events for state changes, incorrect event parameters      | สูง     |
| Centralization Risks | Single admin key, no timelock, unrestricted mint                  | สูง     |
| Front-running        | Susceptible to MEV, missing commit-reveal, no slippage protection | ปานกลาง |

---

## 4. รูปแบบความปลอดภัย DeFi (DeFi Security Patterns)

### Flash Loan Attack Anatomy

```
Flash Loan Attack — Step-by-Step
═══════════════════════════════════════════════════════════════

 Attacker                Flash Loan         DEX (Low         Lending
 Contract                Provider           Liquidity)       Protocol
    │                       │                   │                │
    │  1. Request Flash     │                   │                │
    │     Loan (100M USDC)  │                   │                │
    │──────────────────────>│                   │                │
    │                       │                   │                │
    │  2. Receive 100M USDC │                   │                │
    │<──────────────────────│                   │                │
    │                       │                   │                │
    │  3. Swap 100M USDC → TOKEN_A              │                │
    │     (ราคา TOKEN_A พุ่งขึ้น 10x)            │                │
    │──────────────────────────────────────────>│                │
    │                       │                   │                │
    │  4. Deposit TOKEN_A เป็น collateral       │                │
    │     (ราคา inflated → กู้ได้มากกว่าจริง)    │                │
    │───────────────────────────────────────────────────────────>│
    │                       │                   │                │
    │  5. Borrow 150M USDC  │                   │                │
    │     (เกินมูลค่าจริง)   │                   │                │
    │<──────────────────────────────────────────────────────────│
    │                       │                   │                │
    │  6. Repay Flash Loan  │                   │                │
    │     100M + fee        │                   │                │
    │──────────────────────>│                   │                │
    │                       │                   │                │
    │  7. PROFIT ≈ 50M USDC │                   │                │
    │  (ทั้งหมดใน 1 transaction!)                │                │
    ▼                       ▼                   ▼                ▼

═══════════════════════════════════════════════════════════════
```

### Reentrancy Guard Patterns

| Pattern                           | คำอธิบาย                                   | ข้อดี                          | ข้อเสีย                       |
| --------------------------------- | ------------------------------------------ | ------------------------------ | ----------------------------- |
| Checks-Effects-Interactions (CEI) | Update state ก่อน external call            | ไม่ต้อง gas เพิ่ม              | ต้อง discipline สูง, อาจพลาด  |
| ReentrancyGuard (mutex)           | ใช้ lock variable ป้องกันเข้าซ้ำ           | ง่าย, ชัดเจน                   | เพิ่ม gas ~2,100 (cold SLOAD) |
| EIP-1153 Transient Storage        | ใช้ transient storage สำหรับ lock (Dencun) | ถูกกว่า — ~100 gas             | ต้อง Solidity 0.8.24+         |
| Pull Payment                      | ผู้รับ claim เอง แทนที่ contract จะ push   | ป้องกัน reentrancy โดยธรรมชาติ | UX แย่กว่า — ต้อง claim แยก   |

### Oracle Manipulation: TWAP vs Spot Price

```
Price Manipulation Resistance

  Spot Price (Instant)          TWAP (Time-Weighted Average)
  ┌─────────────────────┐       ┌─────────────────────────┐
  │     ▲ Manipulated   │       │                         │
  │    ╱ ╲              │       │         ─────           │
  │   ╱   ╲             │       │    ────╱     ╲────      │
  │  ╱     ╲  Real      │       │  ──╱              ╲──── │
  │ ╱       ╲──────     │       │ ╱                       │
  │╱                    │       │╱    TWAP smooths out     │
  │                     │       │     manipulation spikes  │
  └─────────────────────┘       └─────────────────────────┘
       ⚠ VULNERABLE                  ✓ MORE RESISTANT
```

**Chainlink Best Practices**:

```solidity
// SECURE — ใช้ Chainlink Price Feed อย่างถูกต้อง
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract SecurePriceConsumer {
    AggregatorV3Interface internal priceFeed;
    uint256 public constant HEARTBEAT = 3600; // 1 hour

    function getLatestPrice() public view returns (uint256) {
        (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        ) = priceFeed.latestRoundData();

        // Validation checks — ขาดอันใดอันหนึ่งถือว่า VULNERABLE
        require(answer > 0, "Negative price");
        require(updatedAt > 0, "Round not complete");
        require(answeredInRound >= roundId, "Stale price");
        require(block.timestamp - updatedAt <= HEARTBEAT, "Price too old");

        return uint256(answer);
    }
}
```

### Sandwich Attacks & MEV Protection

```
Sandwich Attack Flow:
═════════════════════════════════════════════════════
                    Mempool
                       │
  1. Victim submits    │   2. MEV Bot detects
     swap TX           │      victim's pending TX
     (buy TOKEN_A)     │      in mempool
         │             │         │
         ▼             │         ▼
  ┌──────────────┐     │   ┌──────────────────┐
  │ Victim TX    │     │   │ Bot: Front-run    │
  │ Buy TOKEN_A  │     │   │ (buy TOKEN_A      │
  │ slippage 5%  │     │   │  before victim)   │
  └──────────────┘     │   └──────────────────┘
                       │         │
                       │         ▼
                       │   ┌──────────────────┐
                       │   │ Victim TX executes│
                       │   │ (worse price due  │
                       │   │  to front-run)    │
                       │   └──────────────────┘
                       │         │
                       │         ▼
                       │   ┌──────────────────┐
                       │   │ Bot: Back-run     │
                       │   │ (sell TOKEN_A     │
                       │   │  at higher price) │
                       │   └──────────────────┘
═════════════════════════════════════════════════════
```

**MEV Protection Strategies**:

| Strategy             | คำอธิบาย                                       | ตัวอย่าง                            |
| -------------------- | ---------------------------------------------- | ----------------------------------- |
| Private Mempool      | ส่ง TX ผ่าน private RPC ไม่ผ่าน public mempool | Flashbots Protect, MEV Blocker      |
| Commit-Reveal Scheme | ซ่อน intent ใน commit, เปิดเผยทีหลัง           | ENS domain auctions                 |
| Batch Auctions       | รวม orders แล้ว execute พร้อมกัน ราคาเดียว     | CoW Protocol (Coincidence of Wants) |
| Slippage Protection  | ตั้ง max slippage tolerance ต่ำ                | Uniswap slippage settings           |
| Time-locked Orders   | ใช้ time delay ป้องกัน instant front-running   | TWAP order execution                |

### Governance Attack Patterns

| Attack Type           | คำอธิบาย                                                | ตัวอย่างจริง                    |
| --------------------- | ------------------------------------------------------- | ------------------------------- |
| Flash Loan Governance | ยืม governance tokens ด้วย flash loan เพื่อ vote        | Beanstalk ($182M, April 2022)   |
| Vote Buying           | ซื้อ votes ผ่าน bribery platforms                       | Various via Votium, Hidden Hand |
| Proposal Manipulation | สร้าง malicious proposal ที่ดูถูกต้องแต่ซ่อน backdoor   | Tornado Cash governance attack  |
| Timelock Bypass       | โจมตีระหว่าง timelock period หรือ exploit timelock bugs | Rare but critical when found    |

---

## 5. การจัดการ Wallet และ Key (Wallet & Key Management)

### Hot vs Cold Wallet Comparison

| Attribute      | Hot Wallet                        | Cold Wallet                            |
| -------------- | --------------------------------- | -------------------------------------- |
| การเชื่อมต่อ   | Online ตลอดเวลา                   | Offline / air-gapped                   |
| ความสะดวก      | สูง — ทำ transaction ได้ทันที     | ต่ำ — ต้องเชื่อมต่อก่อน sign           |
| ความปลอดภัย    | ต่ำ — เสี่ยง remote attacks       | สูง — ต้อง physical access             |
| ใช้งาน         | Daily operations, small amounts   | Long-term storage, large reserves      |
| ตัวอย่าง       | MetaMask, Trust Wallet, Exchange  | Ledger, Trezor, air-gapped laptop      |
| ความเสี่ยงหลัก | Malware, phishing, key extraction | Physical theft, supply chain tampering |
| แนะนำสัดส่วน   | ≤5% ของ total holdings            | ≥95% ของ total holdings                |

### Multi-Sig Patterns

```
Multi-Signature Wallet Architecture
═══════════════════════════════════════════════════

  2-of-3 Multi-Sig (Operational)
  ┌─────────────────────────────────────┐
  │  Signer A ─────┐                   │
  │  (CEO)         │                   │
  │                ├──→ 2 signatures   │
  │  Signer B ─────┘    required       │──→ TX Executed
  │  (CTO)                             │
  │                                    │
  │  Signer C (CFO) — backup signer    │
  └─────────────────────────────────────┘

  3-of-5 Multi-Sig (Treasury)
  ┌─────────────────────────────────────┐
  │  Signer 1 ─────┐                   │
  │  Signer 2 ─────┤                   │
  │  Signer 3 ─────┘  3 signatures     │──→ TX Executed
  │                    required         │
  │  Signer 4 ──── backup signers      │
  │  Signer 5 ────                     │
  └─────────────────────────────────────┘

  Recommended: gnosis Safe (Safe{Wallet})
  - On-chain multi-sig — audited, battle-tested
  - Module system — timelock, spending limits, recovery
  - Multi-chain — same address across EVM chains
```

**Multi-Sig Operational Security**:

| Guideline                 | คำอธิบาย                                             |
| ------------------------- | ---------------------------------------------------- |
| Geographic Distribution   | Signers อยู่คนละสถานที่ ป้องกัน physical compromise  |
| Device Diversity          | ใช้ hardware wallet คนละยี่ห้อ (Ledger + Trezor)     |
| Communication Security    | ใช้ encrypted channels สำหรับ coordination           |
| Regular Key Rotation      | เปลี่ยน signers เมื่อคนออกจากทีม                     |
| Transaction Review        | ทุก signer ต้อง verify calldata ก่อน sign            |
| Simulation Before Signing | ใช้ Tenderly หรือ Foundry simulate TX ก่อน sign จริง |

### Hardware Wallet Security Model

| Layer           | Protection                                                 |
| --------------- | ---------------------------------------------------------- |
| Secure Element  | Private key ไม่เคยออกจาก chip — sign ภายใน SE เท่านั้น     |
| PIN Protection  | ต้องใส่ PIN ก่อนใช้งาน, lockout หลัง failed attempts       |
| Physical Button | ต้องกดยืนยันบนตัวเครื่อง — malware ไม่สามารถ bypass ได้    |
| Display         | แสดง TX details บน trusted display — ป้องกัน address swap  |
| Firmware        | Signed firmware updates only — ป้องกัน supply chain attack |

### MPC (Multi-Party Computation) Wallets

MPC wallets แบ่ง private key เป็น shares (key shards) กระจายให้หลาย parties
ไม่มี single point ที่มี complete key — sign โดยใช้ threshold scheme

| Feature             | Multi-Sig                        | MPC Wallet                            |
| ------------------- | -------------------------------- | ------------------------------------- |
| Key Storage         | แต่ละ signer มี complete key     | ไม่มีใครมี complete key — มีแค่ shard |
| On-chain Footprint  | Multi-sig contract on-chain      | ดูเหมือน EOA ธรรมดา                   |
| Gas Cost            | สูงกว่า — ต้อง verify signatures | เท่า EOA — single signature on-chain  |
| Key Rotation        | ต้องเปลี่ยน on-chain             | Off-chain key refresh ได้             |
| Chain Compatibility | ต้อง deploy contract ทุก chain   | ใช้ได้ทุก chain (chain-agnostic)      |
| ตัวอย่าง            | Safe{Wallet}                     | Fireblocks, Lit Protocol, Qredo       |

### Key Derivation Standards

| Standard | ชื่อ                       | คำอธิบาย                                             |
| -------- | -------------------------- | ---------------------------------------------------- |
| BIP-32   | Hierarchical Deterministic | สร้าง key tree จาก single seed — parent → child keys |
| BIP-39   | Mnemonic Seed Phrases      | แปลง entropy เป็น 12/24 words สำหรับ backup seed     |
| BIP-44   | Multi-Account Hierarchy    | กำหนด derivation path: m/44'/60'/0'/0/0 (Ethereum)   |

### Seed Phrase Security Practices

- [ ] เก็บ seed phrase บน metal plate (ทนไฟ/น้ำ) ไม่ใช่กระดาษ
- [ ] ไม่เก็บ seed phrase ใน digital format (no photos, no cloud, no notes app)
- [ ] ใช้ Shamir's Secret Sharing (SSS) แบ่ง seed เป็น shares
- [ ] เก็บ shares คนละสถานที่ (bank vault, trusted person, fire safe)
- [ ] ทดสอบ recovery process อย่างน้อยปีละครั้ง
- [ ] ไม่แชร์ seed phrase กับใคร — ไม่มี legitimate service ใดที่ต้องการ seed phrase ของคุณ

---

## 6. ความปลอดภัย Bridge และ Cross-chain (Bridge & Cross-chain Security)

### Bridge Architecture Types

```
Bridge Architecture Comparison
═══════════════════════════════════════════════════════════════

  1. Lock-and-Mint
  ┌──────────┐           ┌──────────┐
  │ Chain A   │  lock     │ Chain B   │
  │           │ ────────> │           │
  │ [Token]   │  mint     │ [wToken]  │
  │  locked   │ <──────── │  minted   │
  └──────────┘           └──────────┘
  ตัวอย่าง: Wormhole, Portal Bridge

  2. Burn-and-Mint
  ┌──────────┐           ┌──────────┐
  │ Chain A   │  burn     │ Chain B   │
  │           │ ────────> │           │
  │ [Token]   │  mint     │ [Token]   │
  │  burned   │ <──────── │  minted   │
  └──────────┘           └──────────┘
  ตัวอย่าง: Circle CCTP (native USDC)

  3. Liquidity Pool
  ┌──────────┐           ┌──────────┐
  │ Chain A   │  deposit  │ Chain B   │
  │           │ ────────> │           │
  │ [Pool A]  │  withdraw │ [Pool B]  │
  │           │ <──────── │           │
  └──────────┘           └──────────┘
  ตัวอย่าง: Stargate, Across Protocol
```

### Bridge Attack History

| Date     | Bridge   | Loss (USD) | Attack Vector                                                | Root Cause                                            |
| -------- | -------- | ---------- | ------------------------------------------------------------ | ----------------------------------------------------- |
| Mar 2022 | Ronin    | $625M      | Private key compromise — 5 of 9 validators compromised       | Social engineering + insufficient validator diversity |
| Feb 2022 | Wormhole | $320M      | Signature verification bypass ใน Solana guardian set         | Uninitialized sysvar account, missing validation      |
| Aug 2022 | Nomad    | $190M      | Message verification bypass — ทุก message ถูก consider valid | Trusted root initialized to 0x00 (accepts all)        |
| Jun 2022 | Harmony  | $100M      | Multi-sig compromise — 2 of 5 signers compromised            | Low threshold, single-vendor HSMs                     |
| Jan 2024 | Orbit    | $82M       | Access control vulnerability ใน cross-chain message          | Compromised signer key + insufficient validation      |
| Jul 2024 | Li.Fi    | $11.6M     | Arbitrary call vulnerability ใน bridge aggregator            | Unvalidated call data in diamond proxy facet          |

### Security Patterns for Bridges

| Pattern                   | คำอธิบาย                                                   | Trade-off                               |
| ------------------------- | ---------------------------------------------------------- | --------------------------------------- |
| Multi-Sig Validation      | ต้อง M-of-N validators sign ก่อน relay message             | ง่าย แต่ centralization risk            |
| Optimistic Verification   | Assume valid, มี challenge period สำหรับ fraud proofs      | Latency สูง (challenge window)          |
| ZK Proofs                 | Prove state transition ด้วย zero-knowledge proof           | Secure ที่สุด แต่ compute cost สูง      |
| Light Client Verification | Verify block headers ของ source chain บน destination chain | Trustless แต่ซับซ้อน                    |
| Watchtower Networks       | Independent monitors ที่ watch bridge transactions         | เพิ่ม defense layer แต่ต้อง incentivize |

### Cross-chain Message Verification Checklist

- [ ] ตรวจสอบ message source chain — ปฏิเสธ messages จาก unknown chains
- [ ] ตรวจสอบ message sender — verify ว่ามาจาก authorized contract
- [ ] ตรวจสอบ message nonce — ป้องกัน replay attacks
- [ ] ตรวจสอบ message expiry — reject stale messages
- [ ] ใช้ multi-sig/MPC สำหรับ validator set (≥ 5 validators, threshold ≥ 67%)
- [ ] มี fraud proof mechanism หรือ challenge period
- [ ] Rate limit bridge transfers — ตั้ง maximum per TX และ per time window
- [ ] มี emergency pause mechanism — circuit breaker เมื่อตรวจพบ anomaly
- [ ] Monitor bridge TVL changes — alert เมื่อ outflow ผิดปกติ
- [ ] ทำ cross-chain replay protection — ป้องกัน TX replay ข้าม chain

---

## 7. เครื่องมือความปลอดภัย (Security Tools)

### Smart Contract Security Tools Comparison

| Tool      | Type                  | Language        | License     | Best For                        | Maturity |
| --------- | --------------------- | --------------- | ----------- | ------------------------------- | -------- |
| Slither   | Static analysis       | Solidity        | Open source | Quick vulnerability scan        | High     |
| Mythril   | Symbolic execution    | Solidity, Vyper | Open source | Deep path analysis              | High     |
| Echidna   | Property-based fuzzer | Solidity        | Open source | Invariant testing               | High     |
| Foundry   | Testing framework     | Solidity        | Open source | Unit/fuzz/invariant tests       | High     |
| Manticore | Symbolic execution    | Solidity, EVM   | Open source | Formal analysis                 | Medium   |
| Certora   | Formal verification   | Solidity        | Commercial  | Mathematical proofs             | High     |
| Aderyn    | Static analysis       | Solidity        | Open source | Fast AST analysis               | Medium   |
| Halmos    | Symbolic testing      | Solidity        | Open source | Foundry-native symbolic testing | Medium   |
| Medusa    | Fuzzer                | Solidity        | Open source | Parallel fuzz campaigns         | Medium   |
| Wake      | Static + testing      | Solidity        | Open source | All-in-one analysis             | Medium   |

### On-chain Monitoring & Response Tools

| Tool                  | Type               | คำอธิบาย                                             | License     |
| --------------------- | ------------------ | ---------------------------------------------------- | ----------- |
| Forta                 | Monitoring network | Decentralized bot network ตรวจจับ threats real-time  | Open source |
| OpenZeppelin Defender | Security platform  | Automated monitoring, incident response, admin mgmt  | Commercial  |
| Tenderly              | Simulation         | TX simulation, debugging, alerting, war rooms        | Freemium    |
| Chainalysis           | Chain analysis     | AML/KYT compliance, sanctions screening              | Commercial  |
| Elliptic              | Chain analysis     | Transaction monitoring, risk scoring                 | Commercial  |
| Hexagate              | Threat detection   | Pre-transaction threat detection, exploit prevention | Commercial  |

### CI/CD Integration for Smart Contract Security

```yaml
# .github/workflows/smart-contract-security.yml
name: Smart Contract Security Pipeline
on:
  push:
    paths: ["contracts/**", "test/**"]
  pull_request:
    paths: ["contracts/**", "test/**"]

jobs:
  security-scan:
    runs-on: ubuntu-latest
    steps:
      # 1. Static Analysis — Slither
      - name: Run Slither
        uses: crytic/slither-action@v0.4.0
        with:
          solc-version: "0.8.24"
          slither-args: "--filter-paths node_modules"
          fail-on: "medium" # fail on medium+ findings

      # 2. Static Analysis — Aderyn (fast AST-based)
      - name: Run Aderyn
        run: |
          aderyn . --output report.json
          # Fail if high/critical findings
          jq '.high_issues | length' report.json | \
            xargs -I {} test {} -eq 0

      # 3. Unit + Fuzz Tests — Foundry
      - name: Run Foundry Tests
        run: |
          forge test --fuzz-runs 10000 -vvv
          forge coverage --report lcov
          # Enforce minimum coverage
          lcov --summary lcov.info | \
            grep 'lines' | \
            awk -F'%' '{if ($1 < 90) exit 1}'

      # 4. Property-Based Fuzzing — Echidna
      - name: Run Echidna
        run: |
          echidna . --contract EchidnaTest \
            --config echidna.yaml \
            --test-limit 50000

      # 5. Formal Verification — Certora (if configured)
      - name: Run Certora Prover
        if: env.CERTORAKEY != ''
        env:
          CERTORAKEY: ${{ secrets.CERTORAKEY }}
        run: |
          certoraRun certora/conf/verify.conf
```

### Tool Selection Guide by Project Stage

| Stage        | Tools                               | คำอธิบาย                                  |
| ------------ | ----------------------------------- | ----------------------------------------- |
| Development  | Foundry, Slither, Aderyn            | Fast feedback loop ระหว่าง development    |
| Pre-audit    | Echidna, Mythril, Halmos            | Deep analysis ก่อนส่ง audit               |
| Audit        | Certora, Manticore, manual review   | Formal verification + expert review       |
| Pre-mainnet  | Tenderly simulation, testnet deploy | Simulate real-world scenarios             |
| Post-mainnet | Forta, OZ Defender, Chainalysis     | Continuous monitoring + incident response |

---

## 8. บริบทประเทศไทย (Thai Context — บริบทประเทศไทย)

### SEC กลต. Digital Asset Regulations

**พ.ร.ก. สินทรัพย์ดิจิทัล พ.ศ. 2561** (Emergency Decree on Digital Asset Businesses B.E. 2018)
เป็นกฎหมายหลักที่กำกับดูแลสินทรัพย์ดิจิทัลในประเทศไทย ภายใต้การกำกับของ สำนักงาน ก.ล.ต. (SEC Thailand)

| ประเด็น              | รายละเอียด                                                      |
| -------------------- | --------------------------------------------------------------- |
| ขอบเขต               | ครอบคลุม cryptocurrency, digital tokens (utility + investment)  |
| ผู้ประกอบธุรกิจ      | ต้องได้รับใบอนุญาตจาก กลต. ก่อนดำเนินธุรกิจ                     |
| ICO / Token Offering | ต้องยื่น filing กับ กลต. ผ่าน ICO Portal ที่ได้รับอนุมัติ       |
| DeFi / DEX           | ยังไม่มีกรอบกำกับชัดเจน — อยู่ระหว่างศึกษา (กลต. sandbox)       |
| NFT                  | กลต. ระบุว่า NFT ที่มีลักษณะ investment contract ต้องปฏิบัติตาม |
| ภาษี                 | เก็บภาษี 15% withholding tax จากกำไรสินทรัพย์ดิจิทัล            |
| Stablecoin           | อยู่ภายใต้การกำกับของ ธปท. (BoT) ร่วมกับ กลต.                   |

### Thai Licensed Crypto Exchanges

| Exchange   | ประเภทใบอนุญาต         | สถานะ        | หมายเหตุ                            |
| ---------- | ---------------------- | ------------ | ----------------------------------- |
| Bitkub     | Digital Asset Exchange | Active       | ตลาดหลักของไทย, market share สูงสุด |
| Satang Pro | Digital Asset Exchange | Active       | รองรับ THB pairs                    |
| Zipmex     | Digital Asset Exchange | ระงับบางส่วน | ปัญหาสภาพคล่องปี 2022               |
| Upbit TH   | Digital Asset Exchange | Active       | Joint venture กับ Upbit Korea       |
| ERX        | Digital Asset Exchange | Active       | เน้น institutional                  |

### BoT CBDC Pilot (Project Inthanon / mBridge)

| Project     | คำอธิบาย                                              | สถานะ (2025)      |
| ----------- | ----------------------------------------------------- | ----------------- |
| Inthanon    | Wholesale CBDC pilot ของ ธปท. บน DLT (Corda → custom) | Phase 3 completed |
| mBridge     | Cross-border CBDC — ร่วมกับ BIS, PBoC, HKMA, CBUAE    | MVP launched      |
| Retail CBDC | CBDC สำหรับประชาชน — อยู่ระหว่างศึกษาความเป็นไปได้    | Study phase       |

**Security Implications สำหรับ CBDC**:

| ความเสี่ยง                      | แนวทาง                                                  |
| ------------------------------- | ------------------------------------------------------- |
| Smart contract bugs             | Formal verification บน CBDC contract, multiple audits   |
| Privacy vs transparency         | Zero-knowledge proofs สำหรับ transaction privacy        |
| Consensus mechanism security    | Byzantine Fault Tolerant consensus, validator diversity |
| Key management for central bank | HSM + MPC สำหรับ central bank keys                      |
| Cross-border interoperability   | Standardized messaging protocol (ISO 20022 alignment)   |

### Anti-Money Laundering (ปปง. Requirements)

สำนักงาน ปปง. (AMLO — Anti-Money Laundering Office) กำหนดให้ผู้ประกอบธุรกิจสินทรัพย์ดิจิทัลต้อง:

- [ ] **KYC/CDD**: ทำ Know Your Customer ระดับ Enhanced Due Diligence
- [ ] **Transaction Monitoring**: ตรวจจับ suspicious transactions ด้วย chain analysis tools
- [ ] **STR Reporting**: รายงาน Suspicious Transaction Report ต่อ ปปง. ภายในกำหนด
- [ ] **Travel Rule**: ปฏิบัติตาม FATF Travel Rule — ส่งข้อมูลผู้โอน/ผู้รับเมื่อ ≥ 1,000 USD
- [ ] **Sanctions Screening**: ตรวจสอบ wallet addresses กับ OFAC SDN list และ sanctions lists อื่น
- [ ] **Record Keeping**: เก็บบันทึกธุรกรรมอย่างน้อย 5 ปี

### Thai DeFi Regulatory Landscape

| หัวข้อ                       | สถานะ (2025)                                                   |
| ---------------------------- | -------------------------------------------------------------- |
| DeFi Protocol Operation      | ไม่มีกรอบกำกับเฉพาะ — อยู่ระหว่างศึกษา                         |
| DEX (Decentralized Exchange) | กลต. ศึกษาแนวทาง — ยังไม่มี licensing framework                |
| Yield Farming / Staking      | รายได้อาจต้องเสียภาษีเงินได้ตามประเภทรายได้                    |
| DAO Governance               | ไม่มีสถานะ legal entity ตามกฎหมายไทย — อาจจัดตั้งเป็นนิติบุคคล |
| Smart Contract Liability     | ยังไม่ชัดเจน — ใช้หลัก พ.ร.บ. คอมพิวเตอร์ 2560 เป็นพื้นฐาน     |
| Regulatory Sandbox           | กลต. เปิด sandbox สำหรับ fintech/DeFi innovation               |

### ก.ล.ต. Regulatory Updates 2025-2026

ก.ล.ต. อยู่ระหว่างปรับปรุงกฎเกณฑ์สำคัญหลายฉบับสำหรับ digital asset ecosystem:

| Update Area                  | สถานะ (ณ มีนาคม 2026)                                | ผลกระทบต่อ Security                                             |
| ---------------------------- | ---------------------------------------------------- | --------------------------------------------------------------- |
| DeFi/DEX Licensing Framework | อยู่ระหว่างศึกษา — คาดประกาศ draft 2026-2027         | DEX ที่ให้บริการในไทยอาจต้อง apply license + audit              |
| NFT Classification Update    | แยก utility NFT ออกจาก investment token (2025)       | Utility NFT ไม่ต้อง filing, investment NFT ยังคง regulated      |
| Stablecoin Oversight         | ธปท. + ก.ล.ต. ร่วมกำกับ (MoU 2024)                   | Stablecoin issuer ต้อง maintain reserves, audit quarterly       |
| ICO Portal Requirements      | เข้มงวดขึ้น — เพิ่ม smart contract audit requirement | ICO ต้องผ่าน security audit จาก approved firm ก่อน listing      |
| Sandbox Graduation Criteria  | กำลังจัดทำ framework (2026)                          | Sandbox projects ต้องผ่าน security assessment ก่อน full license |

### ICO Portal — Smart Contract Security Requirements

ก.ล.ต. กำหนดให้ ICO ที่ยื่นผ่าน ICO Portal ต้องมี:

1. **Smart Contract Audit Report** จาก auditor ที่ ก.ล.ต. approve
   - Minimum: static analysis (Slither/Mythril) + manual code review
   - Audit report ต้อง publish พร้อม whitepaper
2. **Token Metadata Standards** — ERC-20 compliant, symbol registered กับ ก.ล.ต.
3. **Whitepaper Approval** — submit ผ่าน ICO Portal, review period 30-60 วัน
4. **Lock-up Period** — token ของ founders/team ต้อง lock อย่างน้อย 6-12 เดือน post-ICO
5. **Investor Protection** — refund mechanism ถ้า project ไม่ดำเนินการตาม roadmap

### Digital Asset Custodian Standards (มาตรฐานผู้ดูแลสินทรัพย์ดิจิทัล)

ก.ล.ต. กำหนดมาตรฐานสำหรับผู้ประกอบธุรกิจ Digital Asset Custodian:

| Requirement               | รายละเอียด                                                                                  |
| ------------------------- | ------------------------------------------------------------------------------------------- |
| **Key Management**        | ต้องใช้ HSM (Hardware Security Module) สำหรับ private key storage ระดับ FIPS 140-2 Level 3+ |
| **Asset Segregation**     | แยก customer assets ออกจาก company assets ทั้ง on-chain + off-chain                         |
| **Cold/Hot Wallet Ratio** | เก็บ ≥ 95% ใน cold storage, hot wallet เฉพาะ operational needs                              |
| **Multi-signature**       | ใช้ multi-sig (≥ 2-of-3) สำหรับ cold wallet withdrawals                                     |
| **Insurance**             | ต้องทำประกันภัยสินทรัพย์ดิจิทัล (cyber insurance + crime coverage)                          |
| **Audit**                 | ตรวจสอบโดยผู้สอบบัญชีที่ ก.ล.ต. approve — อย่างน้อยปีละ 1 ครั้ง                             |
| **Proof of Reserves**     | ต้อง publish Proof of Reserves (Merkle tree) quarterly                                      |
| **Recovery Procedures**   | จัดทำ disaster recovery plan + key recovery procedures ทดสอบ semi-annually                  |
| **Compliance**            | สอดคล้องกับ ธปท. IT Risk Management + ก.ล.ต. digital asset regulations                      |

---

## 9. รายการตรวจสอบความปลอดภัย Web3 (Web3 Security Checklist)

### Tier 1: Quick Win — เริ่มต้นทันที (Week 1-2)

- [ ] Run Slither static analysis บน contracts ทั้งหมด — แก้ findings ระดับ High+
- [ ] Run Aderyn AST analysis — ตรวจ common anti-patterns
- [ ] ใช้ Solidity 0.8.0+ (built-in overflow/underflow protection)
- [ ] Implement access control ด้วย OpenZeppelin AccessControl/Ownable
- [ ] ใช้ Checks-Effects-Interactions (CEI) pattern ทุก external call
- [ ] เพิ่ม ReentrancyGuard บน functions ที่มี external calls + state changes
- [ ] ตรวจสอบ input validation ทุก public/external function — zero address, ranges, bounds
- [ ] ตั้ง slippage protection ใน DEX integrations
- [ ] ใช้ Chainlink Price Feeds แทน spot price oracles — ตรวจ heartbeat + staleness
- [ ] Foundry unit tests ครอบคลุม happy path + edge cases (coverage > 80%)
- [ ] ตรวจสอบ external call return values ทั้งหมด — ไม่เพิกเฉย return values
- [ ] ไม่ใช้ `tx.origin` สำหรับ authentication — ใช้ `msg.sender` เท่านั้น

### Tier 2: Standard — ก่อน Mainnet Deploy (Week 3-6)

- [ ] **External Audit**: จ้าง reputable audit firm ก่อน mainnet deploy
- [ ] **Formal Verification**: ใช้ Certora สำหรับ critical invariants (เช่น total supply, balances)
- [ ] **Fuzz Testing**: Echidna + Foundry fuzz tests — minimum 50,000 runs per property
- [ ] **Monitoring**: ติดตั้ง Forta bots หรือ OpenZeppelin Defender สำหรับ on-chain monitoring
- [ ] **Multi-sig Governance**: ใช้ Safe{Wallet} multi-sig สำหรับ admin functions (≥ 2-of-3)
- [ ] **Timelock**: ใช้ timelock contract สำหรับ governance actions (≥ 24h delay)
- [ ] **Upgrade Safety**: ถ้าใช้ proxy pattern — ใช้ OpenZeppelin UUPS, ตรวจ storage layout
- [ ] **Emergency Pause**: implement circuit breaker / pause mechanism สำหรับ emergencies
- [ ] **Event Emissions**: emit events สำหรับทุก state change ที่สำคัญ
- [ ] **Documentation**: จัดทำ NatSpec documentation สำหรับ public functions ทั้งหมด
- [ ] **Deployment Script**: ใช้ deterministic deployment (CREATE2) พร้อม verification scripts
- [ ] **Testnet Deployment**: deploy และทดสอบบน testnet อย่างน้อย 2 สัปดาห์ก่อน mainnet

### Tier 3: Advanced — Security Excellence (Ongoing)

- [ ] **Bug Bounty Program**: เปิด bug bounty ผ่าน Immunefi หรือ HackerOne (min payout $10K critical)
- [ ] **Formal Verification**: Certora specs ครอบคลุม core protocol invariants ทั้งหมด
- [ ] **MEV Protection**: ใช้ Flashbots Protect หรือ MEV Blocker สำหรับ user transactions
- [ ] **Cross-chain Monitoring**: ตั้ง monitoring สำหรับ bridge operations และ cross-chain messages
- [ ] **Incident Response Plan**: จัดทำ Web3-specific incident response playbook
- [ ] **War Room Drills**: ซ้อม emergency response อย่างน้อย quarterly
- [ ] **Economic Audits**: จ้าง economic security audit — simulation ด้วย agent-based models
- [ ] **Continuous Auditing**: จ้าง audit firm ทำ continuous review เมื่อ code changes
- [ ] **Red Team Exercises**: จ้าง red team ทดสอบ protocol semi-annually
- [ ] **Governance Security**: ใช้ vote escrow, delegation, anti-flash-loan governance
- [ ] **Supply Chain**: pin dependencies, verify checksums, use lockfiles
- [ ] **Post-Quantum Readiness**: ติดตามและเตรียมพร้อมสำหรับ post-quantum cryptography migration

### Frameworks Quick Reference

| Framework                                     | Version | Focus Area                   | URL / Reference                                   |
| --------------------------------------------- | ------- | ---------------------------- | ------------------------------------------------- |
| OWASP Smart Contract Top 10                   | 2026    | Primary risk taxonomy        | owasp.org/www-project-smart-contract-top-10       |
| OWASP Smart Contract Top 10                   | 2025    | Previous edition comparison  | owasp.org/www-project-smart-contract-top-10       |
| Ethereum Security Best Practices (Consensys)  | Current | Implementation guidelines    | consensys.github.io/smart-contract-best-practices |
| Smart Contract Security Verification Standard | 2.0     | Audit checklist              | github.com/ComposableSecurity/SCSVS               |
| ERC-20 Token Standard                         | Final   | Fungible token interface     | eips.ethereum.org/EIPS/eip-20                     |
| ERC-721 NFT Standard                          | Final   | Non-fungible token interface | eips.ethereum.org/EIPS/eip-721                    |
| ERC-4337 Account Abstraction                  | Draft   | Smart contract wallets       | eips.ethereum.org/EIPS/eip-4337                   |
| NIST IR 8202 Blockchain Technology Overview   | Current | Blockchain fundamentals      | csrc.nist.gov/publications/detail/nistir/8202     |
| FATF Guidance on Virtual Assets               | 2021    | AML/CFT compliance           | fatf-gafi.org                                     |

---

_Web3 & Blockchain Security Reference v1.0 — cybersecurity-pro skill (Domain 22)_
_OWASP Smart Contract Top 10 2026, Smart Contract Audit, DeFi Security, Wallet & Key Management_
