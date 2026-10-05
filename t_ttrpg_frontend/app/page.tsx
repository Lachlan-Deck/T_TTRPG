"use client";

import { handleRoll, RollReturnState } from "./actions/handleRoll";
import { useActionState, useEffect, useState, useRef } from "react";

type HistoryItem = {
  id: string;
  input: string;
  result?: number[];
  error?: string;
};

export default function Home() {
  const [state, formAction, isPending] = useActionState(handleRoll, {
    success: false,
    error: "",
  } as RollReturnState);
  const [history, setHistory] = useState<HistoryItem[]>([]);

  const lastProcessedKey = useRef<string>("");
  const chatEndRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const currentKey = JSON.stringify(state);
    if (currentKey === lastProcessedKey.current) return;

    if (state.success || state.error) {
      lastProcessedKey.current = currentKey;

      const newItem: HistoryItem = {
        id: Math.random().toString(36).substring(2, 9),
        input: "Made a roll",
        result: state.success ? state.data.roll : undefined,
        error: state.error ? state.error : undefined,
      };

      setHistory((prev) => [...prev, newItem]);
    }
  }, [state]);

  useEffect(() => {
    chatEndRef.current?.scrollIntoView({ behavior: "smooth" });
  }, [history]);

  return (
    <main className="flex flex-col h-screen bg-[#282828] text-[#ebdbb2] font-sans">
      {/* Header */}
      <header className="border-b border-[#504945] p-4 text-center bg-[#32302f]/50 backdrop-blur">
        <h1 className="text-xl font-bold tracking-wide text-[#b8bb26] m-0">
          Dice Roller Chat
        </h1>
      </header>

      {/* Chat History Container */}
      <div className="flex-1 overflow-y-auto p-4 md:p-6 space-y-4 max-w-2xl w-full mx-auto">
        {history.length === 0 ? (
          <div className="h-full flex items-center justify-center text-[#928374] text-sm">
            No rolls yet. Type your roll below and press enter or click Roll!
          </div>
        ) : (
          history.map((item) => (
            <div
              key={item.id}
              className="flex flex-col space-y-2 bg-[#32302f] border border-[#504945] p-4 rounded-xl shadow-md"
            >
              <span className="text-xs font-medium text-[#a89984]">
                Roll Result
              </span>
              {item.result ? (
                <div className="flex flex-wrap gap-2">
                  {item.result.map((res, idx) => (
                    <span
                      key={idx}
                      className="bg-[#83a598]/20 border border-[#83a598]/40 text-[#83a598] px-3 py-1 rounded-lg font-mono text-sm"
                    >
                      {res}
                    </span>
                  ))}
                </div>
              ) : (
                <p className="text-[#fb4934] text-sm font-medium">
                  {item.error}
                </p>
              )}
            </div>
          ))
        )}
        <div ref={chatEndRef} />
      </div>

      {/* Centered Sticky Input Box at Bottom */}
      <div className="border-t border-[#504945] bg-[#32302f]/80 backdrop-blur p-4">
        <form
          action={formAction}
          className="max-w-2xl mx-auto flex items-center gap-3"
        >
          <textarea
            name="rollBox"
            rows={1}
            placeholder="Enter your roll expression (e.g., 2d6+3)..."
            className="flex-1 bg-[#1d2021] border border-[#504945] rounded-xl px-4 py-3 text-[#ebdbb2] placeholder-[#928374] focus:outline-none focus:border-[#d3869b] focus:ring-1 focus:ring-[#d3869b] resize-none text-sm"
            onKeyDown={(e) => {
              if (e.key === "Enter" && !e.shiftKey) {
                e.preventDefault();
                e.currentTarget.form?.requestSubmit();
              }
            }}
          />
          <button
            type="submit"
            disabled={isPending}
            className="bg-[#d3869b] hover:bg-[#b16286] text-[#1d2021] font-bold disabled:opacity-50 px-6 py-3 rounded-xl transition-all shadow-lg text-sm cursor-pointer"
          >
            {isPending ? "Rolling..." : "Roll"}
          </button>
        </form>
      </div>
    </main>
  );
}
