"use client";
import { handleRoll } from "./actions/handleRoll";
import { useActionState } from "react";

export default function Home() {
  return (
    <label>
      make your roll
      <form action={handleRoll}>
        <textarea name="rollBox" rows={1} />
        <button type="submit">Roll</button>
      </form>
    </label>
  );
}
