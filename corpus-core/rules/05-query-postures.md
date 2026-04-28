# Query postures

> All paths below are relative to `$CORPUS_VAULT`. Refuse to operate if unset or the vault marker is missing. See [08-vault-structure.md](./08-vault-structure.md).

A question to the wiki can be asked in three very different postures. Treat each one differently — the failure modes are not the same.

## 1. Research (retrieval)

> "Qu'est-ce que le wiki dit déjà sur X ?"

The owner already judged something important and wants it back. **Safe.**

- Read `wiki/index.md` first.
- Read identified pages and adjacent ones.
- Answer using **only** wiki content. Cite pages.
- If the result is a reusable lookup (a comparison table, an implicit taxonomy made explicit), **file it back as a wiki page with `type: reference`.** This compounds the wiki.

## 2. Contradictor (stress-test)

> "Attaque ce wiki. Trouve les angles morts, les hypothèses cachées, les arguments faibles."

The owner asks the model to attack the wiki. **Winning move** — every successful attack reveals a weakness worth recording.

- Identify the position or page being stress-tested.
- Surface counter-arguments, missing perspectives, sources that would falsify the position.
- Cite wiki pages where evidence is thin.
- File the analysis back as a wiki page with **`type: stress-test`**. These pages strengthen the corpus by making weaknesses visible.

## 3. Synthesis (averaging)

> "Donne-moi une synthèse de ce que disent toutes les sources sur X."

The owner asks for an averaged view. **Risky.** A LLM-produced synthesis lisses (smooths) the owner's singular angle by statistical averaging. It must not silently compound into the wiki.

- Produce the synthesis in `output/`, never `wiki/`.
- Flag at the top: `> Note: this is a statistical average across sources, not the owner's singular position.`
- **Never file synthesis back as a wiki page.** No `type: synthesis` exists in the taxonomy on purpose.

## Universal rules — every posture

1. **Read `wiki/index.md` first.** Don't grep blindly across pages.
2. **Use ONLY wiki content** unless the owner explicitly says otherwise.
3. **If the wiki is silent on the question, say so.** Never invent. Never complete with training-data knowledge unless asked.
4. **Cite at the end of every answer**: `Sources: [[page-1]], [[page-2]]`.
5. **Append to `wiki/log.md`**:
   ```
   ## [YYYY-MM-DD] query | <question summary>
   Posture: research | contradictor | synthesis
   Pages consulted: [[a]], [[b]]
   Filed as: [[result-page]]   (research/contradictor only)
   ```

## Why three postures, not one

Treating every query as "research" silently smuggles synthesis behavior into the wiki — the model averages sources because the owner asked open-ended questions and the model wants to be helpful. The posture distinction names the failure mode and segregates its output. See `09-anti-lissage.md`.
