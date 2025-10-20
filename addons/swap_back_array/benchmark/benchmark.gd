extends Node

## Array sizes to test, representing different scales of data (small to very large).[br][br]
## [b]Tuning Considerations:[/b][br]
## - [b]Range:[/b] Covers small (10) to large (10M) arrays to evaluate performance across scenarios. Include sizes relevant to your use case (e.g., typical game object counts). [br]
## - [b]Granularity:[/b] Use logarithmic steps (e.g., 10, 100, 1000) to capture performance trends without excessive tests.[br]
## - [b]Limits:[/b] Very large sizes (e.g., 10M) maystrainmemory or CPU, especially for standard Array’s O(n) removal. If tests stall, cap at 1M or adjust based on hardware.[br]
## - [b]Tuning Tip:[/b] Add intermediate sizes (e.g., 500, 5000) if you need finer granularity, or reduce sizes if memory is constrained.
@export var sizes: Array[int] = [10, 100, 1000, 10000, 100000, 1000000]

## Number of removal operations per run, amplifying measurable time for each test.[br][br]
## [b]Tuning Considerations:[/b][br]
## - [b]Sensitivity:[/b] Higher values (e.g., 5000) ensure small arrays (10, 100) produce measurable times, as single removals are too fast for microsecond precision.[br]
## - [b]Balance:[/b] Must be less than or equal to the array size to avoid emptying the array. For small arrays (e.g., 10), set num_removals <= size or use min(num_removals, arr.size()).[br]
## - [b]Overhead:[/b] Too many removals increase test duration, especially for large arrays with standard Array. Reduce to 1000–2000 if tests are slow.[br]
## - [b]Tuning Tip:[/b] Scale num_removals with array size (e.g., num_removals = max(1000, size / 10)) for proportional testing, or keep fixed for consistency.
@export var num_removals: int = 5000

## Number of runs to average, reducing noise from system variability (e.g., CPU scheduling, garbage collection).[br][br]
## [b]Tuning Considerations:[/b][br]
## - [b]Stability:[/b] Higher values (e.g., 20) smooth out fluctuations, improving reliability. Too few runs (e.g., 5) may give inconsistent results.[br]
## - [b]Time Cost:[/b] More runs increase total benchmark duration. For quick tests, reduce to 10; for high precision, increase to 50.[br]
## - [b]Diminishing Returns:[/b] Beyond 20–30 runs, additional runs yield minimal accuracy gains. Test with 10, 20, 50 to find a sweet spot.[br]
## - [b]Tuning Tip:[/b] Use higher num_runs for smaller arrays where times are near zero, as variance is more impactful.
@export var num_runs: int = 20


func _ready() -> void:
	print("Starting removal benchmarks...")
	run_benchmarks()


func run_benchmarks() -> void:
	for size: int in sizes:
		print("\n--- Array Size: %d ---" % size)

		# Standard Array benchmark
		var standard_time: float = benchmark_standard_array(size, num_removals, num_runs)
		print("Standard Array avg time: %.4f ms" % (standard_time / 1000.0))

		# SwapBackArray benchmark
		var swap_time: float = benchmark_swap_array(size, num_removals, num_runs)
		print("SwapBackArray avg time: %.4f ms" % (swap_time / 1000.0))

		var speedup: float = standard_time / max(swap_time, 0.0001) # Avoid division by zero
		print("Speedup: %.3fx" % speedup)


func benchmark_standard_array(array_size: int, num_removals: int, num_runs: int) -> float:
	var total_time: float = 0.0

	for run: int in num_runs:
		var arr: Array[Node] = []
		for i in array_size:
			arr.append(Node.new())

		var start: float = Time.get_ticks_msec()
		for i: int in num_removals:
			if arr.size() > 0:
				var idx: int = randi() % arr.size()
				arr.remove_at(idx)
		var end: float = Time.get_ticks_msec()

		total_time += end - start
		for node: Node in arr: # Clean up nodes
			node.free()

	return total_time / num_runs


func benchmark_swap_array(array_size: int, num_removals: int, num_runs: int) -> float:
	var total_time: float = 0.0

	for run: int in num_runs:
		var sba: SwapBackArray = SwapBackArray.new()
		for i: int in array_size:
			sba.append(Node.new())

		var start: float = Time.get_ticks_msec()
		for i: int in num_removals:
			if sba.size() > 0:
				var idx: int = randi() % sba.size()
				sba.remove_at(idx)
		var end: float = Time.get_ticks_msec()

		total_time += end - start
		for i: int in sba.size(): # Clean up nodes
			var node: Node = sba.get_by_index(i)
			if node:
				node.free()
	return total_time / num_runs
