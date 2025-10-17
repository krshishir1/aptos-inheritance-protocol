"use client";

function App() {
  return (
    <div className="min-h-screen bg-[#fffff8]">
      <section className="md:w-1/2 mx-auto pt-48">
        <div>
          <div className="">
            {/* <img src="/aptos-logo.svg" alt="Aptos Logo" className="w-6 -translate-y-0.5" /> */}

            <div className="flex items-center justify-between whitespace-nowrap">
              <span style={{fontSize: 38}} className="tracking-wide font-bold">legacy.lock</span>
              <div className="flex gap-3 items-end">
                <span className="text-sm text-neutral-600">built on</span>
                <img src="/aptos-logo.svg" alt="Aptos Logo" className="w-6" />
              </div>
            </div>

            <h3 className="mt-3 pl-1 text-neutral-600 text-lg">
            <i>trustless</i> protocol to pass on crypto and secrets, no <i>middlemen</i> involved
            </h3>

            <div className="pt-24">
              <button className="bg-teal-200 px-4 py-3 italic transition-transform duration-300 ease-out hover:scale-[0.96] main-btn">
                Launching Soon
              </button>
            </div>
          </div>
        </div>
      </section>
    </div>
  );
}

export default App;
