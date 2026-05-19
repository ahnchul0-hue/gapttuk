#!/usr/bin/env python3
"""
serde rename_all 검증 스크립트.

모든 #[derive(Serialize)] 또는 #[derive(..., Serialize, ...)] enum에
#[serde(rename_all = "...")] 속성이 있는지 확인한다.

Night-21에서 3회 연속 serde 파급 누락이 발생하여 CI 자동 검증 도입.
"""
import re
import sys
import os


def check_file(filepath: str) -> list[str]:
    with open(filepath, encoding="utf-8") as f:
        lines = f.readlines()
    issues = []
    i = 0
    while i < len(lines):
        # 연속된 #[...] 속성 블록 수집
        attrs: list[str] = []
        j = i
        while j < len(lines) and re.match(r"\s*#\[", lines[j]):
            attrs.append(lines[j])
            j += 1
        # 다음 줄이 enum 선언인지 확인
        if j < len(lines) and re.match(r"\s*(pub\s+)?enum\s+\w+", lines[j]):
            block = "".join(attrs)
            if "Serialize" in block and "rename_all" not in block:
                issues.append(
                    f"{filepath}:{j + 1}: Serialize enum에 #[serde(rename_all)] 없음"
                    f" → {lines[j].strip()}"
                )
        i = j + 1 if j > i else i + 1
    return issues


def main() -> int:
    root = sys.argv[1] if len(sys.argv) > 1 else "."
    fail = False
    for dirpath, dirnames, filenames in os.walk(root):
        dirnames[:] = [d for d in dirnames if d not in ("target", ".git")]
        for filename in filenames:
            if filename.endswith(".rs"):
                for issue in check_file(os.path.join(dirpath, filename)):
                    print(issue, file=sys.stderr)
                    fail = True
    if fail:
        print(
            "\n[FAIL] 위 enum에 #[serde(rename_all = \"snake_case\")] 를 추가하세요.",
            file=sys.stderr,
        )
    return 1 if fail else 0


if __name__ == "__main__":
    sys.exit(main())
