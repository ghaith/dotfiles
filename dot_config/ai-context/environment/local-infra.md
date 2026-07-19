# Local Infrastructure & Hardware Profile

## Infrastructure Topology
- Compute Node Host: urithiru (Accessed over private Tailscale mesh routing network)
- Local Port Mapping Endpoint: http://urithiru:11434/v1
- Compute Backend Execution Engine: AMD ROCm Pipeline
- Local VRAM Limit: 16 GB Capacity (Radeon RX 9070 XT Hardware Profile)

## Model Profile Mappings
- Multi-Agent Orchestrator: qwen3-coder:30b (Mixture-of-Experts)
- Code Construction Engine: devstral:24b
- Deep Logic Trace Debugger: deepseek-r1:14b
