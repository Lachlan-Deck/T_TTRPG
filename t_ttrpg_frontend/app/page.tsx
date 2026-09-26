"use client";
import { handleRoll, RollReturnState } from "./actions/handleRoll";
import { useActionState } from "react";

const initialState: RollReturnState = { success: false, error: "" };

export default function Home() {
  const [state, formAction, isPending] = useActionState(
    handleRoll,
    initialState,
  );

  return (
    <label>
      make your roll
      <form action={formAction}>
        <textarea name="rollBox" rows={1} />
        <button type="submit" disabled={isPending}>
          {isPending ? "Rolling..." : "Roll"}
        </button>
      </form>
      <div>
        <h3>Roll Result</h3>

        {state.success ? (
          <ul>
            {state.data.roll.map((result, index) => (
              <li key={index}>{result}</li>
            ))}
          </ul>
        ) : (
          state.error && <p style={{ color: "red" }}>{state.error}</p>
        )}
      </div>
      {!state.success && state.error && (
        <p style={{ color: "red", marginTop: "1rem" }}>{state.error}</p>
      )}
    </label>
  );
}
